// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Supernova. All rights reserved.
//
// This file is part of the Deus open-source project.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
// even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If
// not, see https://www.gnu.org/licenses.
// ===-------------------------------------------------------------------------------------------===

import Foundation
import Geometry

/// Closure whose signature matches that of the
/// ``TimeLapseListener/timeDidElapse(on:from:after:towards:)`` callback.
public typealias TimeDidElapse = @Sendable (
  Clock, _ start: Duration, _ previous: Duration?, _ end: Duration
) async -> Void

/// Closure which is executed whenever a ``Clock`` is started.
typealias ClockDidStart = () -> Void

/// Coordinates the passage of time in a simulated universe, allowing for the movement of bodies and
/// other time-based changes to their properties (such as temperature, size, direction, velocity,
/// route, etc.).
///
/// Passage of time is counted per millisecond — referred to here as a _tick_ — from the moment this
/// clock is started and until it is either paused or reset. Each tick can be listened to by adding
/// a listener, which will be notified at each elapsed millisecond.
///
/// - SeeAlso: ``start()``
/// - SeeAlso: ``reset()``
public actor Clock {
  /// ``Mode`` in which this ``Clock`` is ticking or will tick, determining whether its time is that
  /// of a wall-clock or virtual. It is defined as virtual by default — meaning that it will not
  /// elapse automatically when started; rather, it will do so upon explicit calls to
  /// ``advanceTime(by:spacing:)`` —, and can be changed via ``setMode(_:)``.
  private var mode = Mode.virtual

  /// ``Timer`` by which the subticking of this ``Clock`` is scheduled performed periodically when
  /// in wall-clock mode. Will be `nil` in case the mode is virtual or upon an advancement of time,
  /// after which it is initialized and fired again.
  ///
  /// - SeeAlso: ``Mode/wall``
  /// - SeeAlso: ``advanceTime(by:spacing:)``
  private var timer: Timer? = nil

  /// ``ClockStartListener``s to be notified when this ``Clock`` starts.
  ///
  /// - SeeAlso: ``start()``
  private var startListeners = [ClockStartListener]()

  /// ``AnyTimeLapseListener``s to be notified of lapses of time of this ``Clock``.
  private var timeLapseListeners = [AnyTimeLapseListener]()

  /// Total amount of time elapsed.
  private(set) var elapsedTime = Duration.zero

  /// Last time a subtick was performed upon an advancement of time. Stored for determining whether
  /// this ``Clock`` should perform a subtick immediately when advancing its time or only on the
  /// next advancement.
  ///
  /// - SeeAlso: ``advanceTime(by:spacing:)``
  private var lastSubtickTime: Duration? = nil

  /// Whether this ``Clock`` has been last started without a further reset request. Denotes,
  /// ultimately, that it is active.
  ///
  /// - SeeAlso: ``start()``
  /// - SeeAlso: ``reset()``
  private var isTicking = false

  /// Mode based on which a ``Clock`` elapses its time, determines whether its time will be elapsed
  /// automatically until either a mode switch or a reset is performed. Such mode can be defined at
  /// any moment via calls to ``Clock/setMode(_:)``.
  ///
  /// The main difference between the two modes is, essentially, on whether the passage of time upon
  /// a start is automatic — in such case, the ``wall`` mode (meaning "wall-clock mode") would be
  /// used — or manual, requiring explicit advancements — scenario for which ``virtual`` is.
  ///
  /// - SeeAlso: ``Clock/reset()``
  public enum Mode: Sendable {
    /// Denotes that a ``Clock`` should elapse its time only upon command, with explicit calls to
    /// ``Clock/advanceTime(by:spacing:)``. Its ticking is, then, dependent of such advancements,
    /// and does not occur until they are both performed and done so by a sufficient amount — 1,000
    /// microseconds = 1,000 subticks = 1 millisecond = 1 tick.
    ///
    /// This ``Mode`` is especially useful for tests, given that the passage of time can be
    /// precisely controlled and, therefore, is deterministic.
    case virtual

    /// Denotes that a ``Clock`` should elapse its time automatically when started or immediately if
    /// it is currently uninterrupted, via the mechanisms specific to the underlying operating
    /// system.
    case wall

    /// Callback called before this ``Mode`` is set to the `clock`.
    ///
    /// Triggers the system-based passage of time in case this is the ``wall`` ``Mode``; otherwise,
    /// invalidates and dereferences the `Timer`, since the ``virtual`` ``Mode`` requires explicit
    /// advancements of time via ``Clock/advanceTime(by:spacing:)``.
    ///
    /// - Parameter clock: ``Clock`` whose ``Mode`` will be set to this one.
    fileprivate func willBeSet(to clock: isolated Clock) async {
      guard clock.mode != self else { return }
      clock.timer?.invalidate()
      clock.timer = nil
      await willBeSetToAndDidPrepare(clock: clock)
    }

    /// Handles setting the ``Mode`` of the `clock` to this one, considering that the previous
    /// state resulted from the current mode has already been reset and, therefore, it is safe to
    /// perform the configuration specific to this ``Mode``.
    ///
    /// By the time this function is called, it is implicitly guaranteed that:
    ///
    /// - `clock.mode` != `self`;
    /// - `clock.timer` == `nil`.
    ///
    /// - Parameter clock: ``Clock`` whose ``Mode`` will be set to this one.
    private func willBeSetToAndDidPrepare(clock: isolated Clock) async {
      switch self {
      case .virtual: return
      case .wall:
        clock.addStartListener(listening: .once) {
          let timer = Timer(
            timeInterval: 0.000001,
            repeats: true,
            block: { _ in
              Task { await clock.advanceTimeUnconditionally(by: .subticks(1), spacing: .extreme) }
            }
          )
          clock.timer = timer
          timer.fire()
        }
      }
    }
  }

  /// Factor of advancements of time of a ``Clock`` for progressing from its current time toward
  /// another. Ultimately, determines the meantimes to be iterated through and defined as the
  /// current time of the ``Clock`` while such advancement is ongoing.
  ///
  /// - SeeAlso: ``Clock/advanceTime(by:spacing:)``
  public enum Spacing {
    /// Considers only the current time of the ``Clock`` and the target one.
    case extreme

    /// Considers each millisecond between the current time of the ``Clock`` and the target one.
    case linear

    /// Time will be elapsed fastly in the beginning and toward the end of the advancement while
    /// slowly in between.
    case eased

    /// Spaces the given range of time according to this policy.
    ///
    /// - Parameter timeLapse: `ClosedRange` from the current time of the ``Clock`` to that toward
    ///   which an advancement will be performed.
    /// - Returns: Meantimes (possibly including the original start and end ones) to be set as the
    ///   current time of the ``Clock`` while advancing.
    /// - SeeAlso: ``Clock/advanceTime(by:spacing:)``
    fileprivate func space(timeLapse: ClosedRange<Duration>) -> any Sequence<Duration> {
      switch self {
      case .extreme: [timeLapse.lowerBound, timeLapse.upperBound]
      case .linear:
        stride(from: timeLapse.lowerBound, through: timeLapse.upperBound, by: Duration.subtickScale)
      case .eased:
        stride(from: 0.0, through: 1, by: 0.05).map { t in
          .subticks(
            Int(BezierCurve.eased[t].y * .init(timeLapse.upperBound.comprisableSubtickCount))
          )
        }
      }
    }
  }

  /// Determines how time will be elapsed by this ``Clock``: whether virtually — manually —, with
  /// explicit advancements; or as that of a wall-clock, automatically and through the underlying
  /// operating system.
  ///
  /// - Parameter mode: ``Mode`` to be defined and applied in case this ``Clock`` is ticking.
  /// - SeeAlso: ``start()``
  public func setMode(_ mode: Mode) async {
    await mode.willBeSet(to: self)
    self.mode = mode
  }

  /// Initiates the passage of time. From the moment this function is called, this ``Clock`` can
  /// tick on a per-millisecond basis and, upon each of its ticks, the added listeners are notified.
  ///
  /// Calling this function consecutively is a no-op. In case it is called after this ``Clock`` was
  /// paused, the pessage of time is resumed from where it left off; if it was reset, the time is
  /// restarted.
  ///
  /// - SeeAlso: ``reset()``
  public func start() async {
    guard !isTicking else { return }
    isTicking = true
    for listener in startListeners { listener.notify(startOf: self, isImmediate: false) }
  }

  /// Listens to lapses of time of this ``Clock``.
  ///
  /// - Parameter listener: ``TimeLapseListener`` to be added.
  /// - Returns: ID of the `listener` with which it can be later removed.
  /// - SeeAlso: ``removeTimeLapseListener(identifiedAs:)``
  public func addTimeLapseListener(_ listener: some TimeLapseListener) async -> UUID {
    await Task { addAnyTimeLapseListener(.init(listener)) }.value
  }

  /// Listens to lapses of time of this ``Clock``.
  ///
  /// - Parameter timeDidElapse: Callback called whenever the time of this ``Clock`` is elapsed.
  /// - Returns: ID of the ``TimeLapseListener`` with which it can be later removed.
  /// - SeeAlso: ``removeTimeLapseListener(identifiedAs:)``
  public func addTimeLapseListener(_ timeDidElapse: @escaping TimeDidElapse) async -> UUID {
    await Task { addAnyTimeLapseListener(.init(timeDidElapse: timeDidElapse)) }.value
  }

  /// Removes a listener of lapses of time of this ``Clock``.
  ///
  /// - Parameter id: ID of the ``TimeLapseListener`` to be removed.
  public func removeTimeLapseListener(identifiedAs id: UUID) {
    timeLapseListeners.removeFirst(where: { listener in listener.id == id })
  }

  /// Requests the time to be advanced in case this ``Clock`` is ticking.
  ///
  /// - Parameters:
  ///   - advancement: Amount of time by which this ``Clock`` is to be advanced.
  ///   - spacing: Determines the meantimes between `elapsedTime...(elapsedTime + advancement)`
  ///     through which iterate and of which added ``TimeLapseListener``s will be notified for each
  ///     whole tick (1 ms) comprised by such advancement.
  ///
  ///     > Note: Internally, a ``Clock`` elapses its time on a per-microsecond basis. Depending on
  ///     the available computational power, passing in a ``Spacing`` which produces a long range is
  ///     discouraged if the distance between the current time and the target one in microseconds is
  ///     large.

  // TODO: Measure and define exactly what a "large" time range means.
  public func advanceTime(by advancement: Duration, spacing: Spacing) async {
    guard isTicking && advancement != .zero else { return }
    await advanceTimeUnconditionally(by: advancement, spacing: spacing)
  }

  /// Resets this ``Clock``, stopping the passage of time.
  ///
  /// Calling ``start()`` after having called this function starts the passage of time from the
  /// beginning.
  public func reset() async {
    timeLapseListeners.removeAll()
    startListeners.removeAll()
    await setMode(.virtual)
    guard isTicking else { return }
    isTicking = false
    lastSubtickTime = nil
    elapsedTime = .zero
  }

  /// Removes a listener of starts of this ``Clock``.
  ///
  /// - Parameter id: ID of the ``ClockStartListener`` to be removed.
  fileprivate func removeStartListener(identifiedAs id: UUID) {
    startListeners.removeFirst(where: { listener in listener.id == id })
  }

  /// Adds ``advancement`` to the time that has elapsed, notifying each added listener when a tick
  /// is performed. Differs from the public function for advancing time in that this one does not
  /// ensure that this ``Clock`` is ticking or the given ``advancement`` is greater than zero: it is
  /// implied that both conditions are true.
  ///
  /// - Parameters:
  ///   - advancement: Amount of time by which this ``Clock`` is to be advanced.
  ///   - spacing: Determines the meantimes between `elapsedTime...(elapsedTime + advancement)`
  ///     through which iterate and of which added ``TimeLapseListener``s will be notified for each
  ///     whole tick (1 ms) comprised by such advancement.
  /// - SeeAlso: ``advanceTime(by:spacing:)``
  /// - SeeAlso: ``isTicking``
  private func advanceTimeUnconditionally(by advancement: Duration, spacing: Spacing) async {
    let start = elapsedTime
    let end = start + advancement
    for meantime in spacing.space(timeLapse: start...end) {
      elapsedTime = meantime
      guard elapsedTime.canOnlyCompriseWholeTicks && (meantime == start || lastSubtickTime != start)
      else { continue }
      for listener in timeLapseListeners {
        await listener.timeDidElapse(
          on: self,
          from: start,
          after: meantime == start ? nil : max(.zero, meantime - .tick),
          towards: end
        )
      }
    }
    lastSubtickTime = elapsedTime
  }

  /// Listens to starts of this ``Clock``.
  ///
  /// - Parameters:
  ///   - repetition: Denotes whether this ``ClockStartListener`` will continue to be notified after
  ///     subsequent starts.
  ///   - clockDidStart: Callback called whenever this ``Clock`` starts.
  private func addStartListener(
    listening repetition: ClockStartListener.Repetition,
    _ clockDidStart: @escaping ClockDidStart
  ) {
    let listener = ClockStartListener(listening: repetition, clockDidStart: clockDidStart)
    guard !isTicking else {
      listener.notify(startOf: self, isImmediate: true)
      return
    }
    startListeners.append(listener)
  }

  /// Base function for ``AnyTimeLapseListener`` adder functions which adds the `listener` and
  /// provides its ID for later removal.
  ///
  /// - Parameter listener: ``AnyTimeLapseListener`` to be added.
  /// - Returns: ID of the `listener` with which it can be later removed.
  /// - SeeAlso: ``removeTimeLapseListener(identifiedAs:)``
  private func addAnyTimeLapseListener(_ listener: AnyTimeLapseListener) -> UUID {
    timeLapseListeners.append(listener)
    return listener.id
  }
}

/// Listener of lapses of time of a ``Clock``.
public protocol TimeLapseListener: AnyObject, Sendable {
  /// Callback called after a lapse of time of the `clock`.
  ///
  /// - Parameters:
  ///   - clock: ``Clock`` whose time has elapsed.
  ///   - start: Time from which the `clock` is being advanced.
  ///   - previous: Time prior to the current one.
  ///
  ///     The time of a ``Clock`` elapses 1 ms per tick. However, the lapse may also have been the
  ///     result of an advancement; in such a scenario, it could have been advanced immediately
  ///     instead of linearly, and, therefore, the difference between both times might not be of
  ///     only 1 ms.
  ///
  ///     It will be `nil` if this is the first lapse of time of the `clock` and, in this case, the
  ///     current time *may* be zero depending on whether the `clock` has been restarted. If the
  ///     `clock` is resuming, it will be the amount of time elapsed at the moment it was paused.
  ///   - end: Target, final time towards which the time of the ``Clock`` is elapsing.
  func timeDidElapse(
    on clock: Clock,
    from start: Duration,
    after previous: Duration?,
    towards end: Duration
  ) async
}

/// ``TimeLapseListener`` by which an instance of a conforming class can be wrapped in order to be
/// added and listen to the lapses of time of a ``Clock``. A randomly generated ID is assigned to it
/// upo instantiation, which allows for both ensuring that it is added to a ``Clock`` only once and
/// removing it when it should no longer be notified of time lapses.
///
/// - SeeAlso: ``Clock/addTimeLapseListener(_:)-2lfn4``
/// - SeeAlso: ``Clock/removeTimeLapseListener(identifiedAs:)``
private actor AnyTimeLapseListener: Identifiable, TimeLapseListener {
  let id: UUID

  /// Callback to which calls to ``timeDidElapse(from:after:to:toward)`` delegate.
  private(set) var timeDidElapse: TimeDidElapse

  init(_ base: some TimeLapseListener) {
    id = (base as? any Identifiable)?.id as? UUID ?? UUID()
    timeDidElapse = base.timeDidElapse
  }

  init(timeDidElapse: @escaping TimeDidElapse) {
    id = UUID()
    self.timeDidElapse = timeDidElapse
  }

  static func == (lhs: AnyTimeLapseListener, rhs: AnyTimeLapseListener) -> Bool { lhs.id == rhs.id }

  func timeDidElapse(
    on clock: Clock,
    from start: Duration,
    after previous: Duration?,
    towards end: Duration
  ) async { await timeDidElapse(clock, start, previous, end) }
}

/// `Identifiable` listener which is notified of starts of a ``Clock``.
private final class ClockStartListener: Identifiable, Hashable {
  /// Callback called whenever the ``Clock`` starts.
  private let clockDidStart: ClockDidStart

  /// Denotes whether this ``ClockStartListener`` will continue to be notified after subsequent
  /// ``Clock`` starts.
  private let repetition: Repetition

  let id = UUID()

  /// Frequency with which a ``ClockStartListener`` should be notified.
  enum Repetition {
    /// Notification will be performed only once: either immediately, in case the ``Clock`` is
    /// already ticking; or by the time it is started. Further calls to ``Clock/start()`` after the
    /// ``ClockStartListener`` has been notified will be ignored.
    case once

    /// Callback called after the `listener` gets notified.
    ///
    /// Dereferences the `listener` in case this is ``once``.
    ///
    /// - Parameters:
    ///   - clock: ``Clock`` whose start has been listened to.
    ///   - listener: ``ClockStartListener`` to which a start of the `clock` has been notified.
    func didNotify(startOf clock: isolated Clock, to listener: ClockStartListener) {
      switch self {
      case .once: clock.removeStartListener(identifiedAs: listener.id)
      }
    }
  }

  init(listening repetition: Repetition, clockDidStart: @escaping ClockDidStart) {
    self.repetition = repetition
    self.clockDidStart = clockDidStart
  }

  static func == (lhs: ClockStartListener, rhs: ClockStartListener) -> Bool { lhs.id == rhs.id }

  func hash(into hasher: inout Hasher) { id.hash(into: &hasher) }

  /// Notifies this ```ClockStartListener``` of a start of the `clock`, calling its ``clockDidStart``
  /// callback.
  ///
  /// - Parameters:
  ///   - clock: ``Clock`` whose start is being notified.
  ///   - isImmediate: Whether this notification is amid ticks of the ``clock`` — in which case it
  ///     is already started and has not *scheduled* the listening to its starts, but is, rather,
  ///     notifying this ``ClockStartListener`` immediately.
  ///
  ///     Setting this to `false` with `repetition` as ``Repetition/once`` signals that an
  ///     O(`clock.startListeners.count`) lookup for this ``ClockStartListener`` should be performed
  ///     and it should, then, be removed from such `Array`. Means that the listening was, in fact,
  ///     scheduled.
  func notify(startOf clock: isolated Clock, isImmediate: Bool) {
    clockDidStart()
    guard !isImmediate else { return }
    repetition.didNotify(startOf: clock, to: self)
  }
}

extension BezierCurve {
  /// Cubic Bézier curve with P₀ = (0, 0), P₁ = (.25, .1), P₂ = (.25, .1), P₃ = (1, 1).
  fileprivate static let eased: some BezierCurveProtocol = {
    let controller = Point(x: 0.25, y: 0.1)
    let start = Point.zero.controlled(by: controller)
    let end = Point(x: 1, y: 1).controlled(by: controller)
    return BezierCurve.make(from: start, to: end)
  }()
}

extension Array {
  /// Removes the first element of this `Array` matching the `predicate`.
  ///
  /// - Complexity: O(*n*), where *n* is the length of this `Array`.
  /// - Parameter predicate: Condition to be satisfied by an element in order for it to be removed.
  /// - Returns: The removed element, or `nil` if none matched the `predicate`.
  @discardableResult
  fileprivate mutating func removeFirst(
    where predicate: (Element) throws -> Bool
  ) rethrows -> Element? {
    for (index, element) in enumerated() {
      guard try predicate(element) else { continue }
      return remove(at: index)
    }
    return nil
  }
}
