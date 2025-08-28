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

/// Junction of two concepts: that of a manifold, a finite-dimensional, locally-Euclidean
/// topological space; and that of its tangent bundle, a space with each of the points of such
/// manifold paired to their tangent vectors.
///
/// A value is differentiable when the function of which it is an input has a limit and, therefore,
/// can be derived based on an infinitesimal change approaching zero. For calculating either, refer
/// to ``limit(of:)`` and ``derivative(of:)``.
public protocol Differentiable {
  /// Vector in the tangent bundle of the manifold; often referred to as the slope of the point of
  /// the manifold to which it is paired in such bundle.
  associatedtype TangentVector: AdditiveArithmetic & Differentiable

  /// Advances the manifold by the given tangent offset `n`.
  ///
  /// - Parameter advancement: Offset by which this ``Differentiable`` will be moved.
  mutating func advance(by advancement: TangentVector)
}

extension Differentiable where TangentVector == Self {
  mutating public func advance(by n: Self) { self += n }
}
