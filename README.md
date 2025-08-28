<img alt="Logo" src="https://github.com/user-attachments/assets/a3d03dc6-5b02-4f78-b960-f68372a34b27" />
<h1 align="center">Deus</h1>
<div align="center"><blockquote cite="https://users.ece.cmu.edu/~gamvrosi/thelastq.html">And AC said: “LET THERE BE LIGHT!”</blockquote></div>
<br />
<div align="center">
  <a href="https://github.com/jeanbarrossilva/Deus/actions/workflows/test.yml">
    <img alt="CI testing badge" src="https://github.com/jeanbarrossilva/Deus/actions/workflows/test.yml/badge.svg" />
  </a>
</div>
<br />
<p>Deus is a simulator of particle physics whose aim is to simulate the genesis of the Universe, from the Big Bang (t → 0) to the dark ages (t ≈ 370,000 a). It can be adjusted in terms of the laws of physics which are applied, ranging from classical to quantum, allowing for sparing of computing resources for lower-range hardware and visualization of simulated scenarios wherein only Newtonian physics are employed versus those in which quantization is taken into consideration.</p>
<p>Our current, state-of-the-art knowledge is still unable to state, precisely, <i>how</i> the Big Bang occurred — specifically up until the Planck epoch (t = 10⁻⁴³ s).</p>
<figure>
  <a href="https://www.esa.int/ESA_Multimedia/Images/2013/03/Planck_history_of_Universe" target="_blank">
    <img alt="Timeline of the Universe" src="https://github.com/user-attachments/assets/81f8668f-7b8b-4c67-9b30-4623702fbfbd" />
  </a>
  <div align="center">
    <figcaption>© <a href="https://www.esa.int" target="_blank"><abbr title="European Space Agency">ESA</abbr></a>. C. Carreau</figcaption>
  </div>
</figure>
<h2>Requirements</h2>
<table align="center">
  <tr>
    <th>Tool</th>
    <th>Version</th>
  </tr>
  <tr>
    <td>macOS</td>
    <td>15.5</td>
  </tr>
  <tr>
    <td>Swift toolchain</td>
    <td id="requirements-footnote-1-ref">6 (snapshot<a href="#requirements-footnote-1"><sup>1</sup></a>)</td>
  </tr>
  <tr>
    <td>Xcode</td>
    <td>16.4</td>
  </tr>
</table>
<hr />
<ol>
  <li id="requirements-footnote-1">
    <p><a href="https://github.com/project-deus/Deus/tree/main/QuantumMechanics"><code>QuantumMechanics</code></a> relies on <a href="https://github.com/swiftlang/swift/blob/d837d6052cf5403644e14956ee4376454ad633bd/docs/DifferentiableProgramming.md" target="_blank">differentiable programming</a> (for, e.g., calculating the Lagrangian of a point in a manifold), which is implemented by Swift in an unstable module. Differentiation is delegated to such module because <a href="https://github.com/swiftlang/swift/blob/d837d6052cf5403644e14956ee4376454ad633bd/docs/DifferentiableProgramming.md#history-of-differentiation-algorithms" target="_blank">its implementation is far from trivial</a>.</p>
    <p>Only the latest major version of the toolchain can have its snapshot installed. To check which version is the latest major one, refer to the <a href="https://github.com/swiftlang/swift/releases" target="_blank">Releases page of Swift</a>. <a href="#requirements-footnote-1-ref">↩</a></p>
  </li>
</ol>
<h2>Development process</h2>
<p>Some parts of the process of developing Deus are documented by the author himself in his video series <a href="https://youtube.com/playlist?list=PLHiVqgQ7o8farBkJrCzFdJe6hsDT3ight" target="_blank"><cite>Deus: Simulando o Universo</cite></a> (<cite>Deus: Simulating the Universe</cite>), in which the thinking behind the overall structure of the project is explained and important concepts regarding the physics themselves are taught.</p>
<figure>
  <a href="https://www.youtube.com/watch?v=rlKpONUVOWk&list=PLHiVqgQ7o8farBkJrCzFdJe6hsDT3ight" target="_blank">
    <img src="https://github.com/user-attachments/assets/a4f47698-c4b0-4782-b60c-2c7ff4446a9f" />
  </a>
  <div align="center">
    <figcaption>
      <a href="https://www.youtube.com/watch?v=rlKpONUVOWk&list=PLHiVqgQ7o8farBkJrCzFdJe6hsDT3ight" target="_blank"><cite>e se… eu recriasse o universo…?</cite></a>
      <br />
      <span>(<cite>what if… i recreated the universe…?</cite>)</span>
    </figcaption>
  </div>
</figure>
<h2>Special thanks to…</h2>
<ol>
  <li><b>Bernardo Benfeitas</b> and <b>Miguel Aloisio</b>, with both having presented the movie <a href="https://en.wikipedia.org/wiki/Interstellar_(film)" target="_blank"><cite>Interstellar</cite></a>, one of the greatest inspirations for Deus, to the author;</li>
  <li><b>David Tong</b> and <b>Sean Carroll</b>, professors by whom the author was introduced to quantum mechanics in their respective lectures <a href="https://youtu.be/zNVQfWC_evg" target="_blank"><cite>The real building blocks of the Universe (Discourse)</cite></a> and <a href="https://youtu.be/5hVmeOCJjOU" target="_blank"><cite>A brief history of quantum mechanics</cite></a>; and</li>
  <li><b>Savannah Brown</b>, from whom the author learned about <a href="https://users.ece.cmu.edu/~gamvrosi/thelastq.html" target="_blank"><cite>The Last Question</cite></a> by Isaac Asimov, through her essay <a href="https://youtu.be/PDFUgsE6odU" target="_blank"><cite>20 minutes on whether or not the world is getting worse</cite></a>.</li>
</ol>
<p>These are the people who have, directly or indirectly, influenced this project from its conception, without whom it probably would not exist.</p>
