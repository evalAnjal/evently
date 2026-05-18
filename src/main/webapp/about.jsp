<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About Us - Evently</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Caprasimo&display=swap"
      rel="stylesheet"
    />

    <style>
      /* Page background: soft gradient from indigo tint to near-white */
      body {
        background: linear-gradient(180deg, #eef2ff 0%, #f8fafc 100%);
        font-family: "Inter", sans-serif;
        color: #0f172a;
      }

      /* Navbar: frosted glass effect with rounded pill shape */
      nav {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(12px);
        box-shadow: 0 24px 60px rgba(15, 23, 42, 0.08);
        border-radius: 50px;
        height: 80px;
      }

      /* Reusable card shadow utility */
      .card {
        box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
      }
    </style>
  </head>

  <body>
    <!-- PAGE WRAPPER: max-width container centered with padding -->
    <div class="max-w-[1180px] mx-auto px-6 py-8">
      <!-- ===================== NAVBAR ===================== -->
      <div class="flex justify-center mt-10">
        <nav class="w-full flex justify-between items-center px-8 py-4">

          <!-- Brand logo -->
          <img src="../../../logoBlue.png" class="h-24" />

          <!-- Navigation links -->
          <ul class="flex gap-8 font-semibold text-slate-700">
            <li><a href="home-page.jsp" class="hover:text-blue-600">Home</a></li>
            <li><a href="about.jsp" class="hover:text-blue-600">About</a></li>
            <li><a href="member-dashboard.jsp" class="hover:text-blue-600">Events</a></li>
            <li><a href="#" class="hover:text-blue-600">Contact</a></li>
          </ul>

          <!-- Login CTA button -->
          <button
            class="bg-blue-900 text-white px-6 py-2 rounded-full font-bold hover:bg-blue-700"
          >
            Login
          </button>
        </nav>
      </div>

      <!-- ===================== HERO SECTION ===================== -->
      <!-- Centered intro block with page title and short description -->
      <section class="mt-14 bg-white rounded-[36px] p-12 card text-center">
        <h1
          class="text-6xl font-bold mb-6"
          style="font-family: &quot;Caprasimo&quot;, cursive; color: #023793"
        >
          About Evently
        </h1>

        <p class="text-slate-600 text-lg leading-8 max-w-3xl mx-auto">
          Evently is a modern campus event management system designed to
          simplify event creation, registration, ticketing, and coordination for
          students and organizers.
        </p>
      </section>

      <!-- ===================== ABOUT SECTION ===================== -->
      <!-- Two-column layout: feature list (left) + event image (right) -->
      <section class="mt-12 grid lg:grid-cols-3 gap-8">

        <!-- LEFT: Why Choose Evently + numbered feature list -->
        <div class="lg:col-span-2 bg-white p-10 rounded-[36px] card">
          <h2 class="text-3xl font-bold text-blue-900 mb-6">
            Why Choose Evently?
          </h2>

          <p class="text-slate-600 leading-8 mb-8">
            Evently is built for students who want a simple and powerful way to
            manage campus events. It brings all event tools into one platform so
            organizers can focus on experience rather than complexity.
          </p>

          <!-- Numbered feature list -->
          <div class="space-y-5">

            <!-- Feature 1: Easy Event Creation -->
            <div class="flex gap-4">
              <div
                class="bg-blue-900 text-white w-10 h-10 flex items-center justify-center rounded-full"
              >
                1
              </div>
              <div>
                <h3 class="font-bold text-blue-900">Easy Event Creation</h3>
                <p class="text-slate-600 text-sm">
                  Create events in seconds with simple tools.
                </p>
              </div>
            </div>

            <!-- Feature 2: Ticket & Registration -->
            <div class="flex gap-4">
              <div
                class="bg-blue-900 text-white w-10 h-10 flex items-center justify-center rounded-full"
              >
                2
              </div>
              <div>
                <h3 class="font-bold text-blue-900">Ticket & Registration</h3>
                <p class="text-slate-600 text-sm">
                  Manage attendees and registrations easily.
                </p>
              </div>
            </div>

            <!-- Feature 3: Campus Focused -->
            <div class="flex gap-4">
              <div
                class="bg-blue-900 text-white w-10 h-10 flex items-center justify-center rounded-full"
              >
                3
              </div>
              <div>
                <h3 class="font-bold text-blue-900">Campus Focused</h3>
                <p class="text-slate-600 text-sm">
                  Built specifically for college environments.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- RIGHT: Event image card -->
        <div class="bg-white p-6 rounded-[36px] card relative">
          <img
            src="./event.jpg"
            class="rounded-[30px] h-[420px] w-full object-cover"
          />

          <!-- Floating stat badge (currently commented out) -->
          <!-- <div
            class="absolute bottom-10 left-10 bg-white p-5 rounded-2xl shadow-xl"
          >
            <h2 class="text-3xl font-bold text-blue-900">1000+</h2>
            <p class="text-slate-500 text-sm">Events Managed</p>
          </div>
        </div> -->
      </section>

<!-- ===================== MISSION & VISION ===================== -->
<!-- Side-by-side cards explaining the platform's purpose and goals -->
<section class="mt-12 grid md:grid-cols-2 gap-8">

  <!-- Mission card -->
  <div class="bg-white p-10 rounded-[36px] shadow-xl">
    <h2 class="text-3xl font-bold text-blue-900 mb-4"
        style="font-family:'Caprasimo', cursive;">
      Our Mission
    </h2>

    <p class="text-slate-600 leading-8">
      To simplify campus event management by providing an easy, fast,
      and digital platform for students and organizers to create,
      manage, and participate in events.
    </p>
  </div>

  <!-- Vision card -->
  <div class="bg-white p-10 rounded-[36px] shadow-xl">
    <h2 class="text-3xl font-bold text-blue-900 mb-4"
        style="font-family:'Caprasimo', cursive;">
      Our Vision
    </h2>

    <p class="text-slate-600 leading-8">
      To become the most trusted and widely used campus event platform
      that connects students, clubs, and institutions in one digital ecosystem.
    </p>
  </div>

</section>

      <!-- ===================== STATS SECTION ===================== -->
      <!-- Four key impact metrics displayed in a responsive grid -->
      <section class="mt-12 bg-white rounded-[36px] p-10 card">
        <h2
          class="text-3xl font-bold text-blue-900 text-center mb-8"
          style="font-family: &quot;Caprasimo&quot;, cursive"
        >
          Our Impact
        </h2>

        <div class="grid md:grid-cols-4 gap-6">

          <!-- Stat: Total Users -->
          <div
            class="bg-blue-50 p-6 rounded-2xl text-center border border-blue-100"
          >
            <h2 class="text-4xl font-bold text-blue-900">500+</h2>
            <p class="text-slate-600 mt-2">Users</p>
          </div>

          <!-- Stat: Total Events -->
          <div
            class="bg-blue-50 p-6 rounded-2xl text-center border border-blue-100"
          >
            <h2 class="text-4xl font-bold text-blue-900">1000+</h2>
            <p class="text-slate-600 mt-2">Events</p>
          </div>

          <!-- Stat: Active Clubs -->
          <div
            class="bg-blue-50 p-6 rounded-2xl text-center border border-blue-100"
          >
            <h2 class="text-4xl font-bold text-blue-900">50+</h2>
            <p class="text-slate-600 mt-2">Clubs</p>
          </div>

          <!-- Stat: Year Founded -->
          <div
            class="bg-blue-50 p-6 rounded-2xl text-center border border-blue-100"
          >
            <h2 class="text-4xl font-bold text-blue-900">2025</h2>
            <p class="text-slate-600 mt-2">Founded</p>
          </div>
        </div>
      </section>
      <!-- ===================== TESTIMONIALS SECTION ===================== -->
      <!-- Student feedback displayed as a 3-column card grid -->
<section class="mt-14 bg-white rounded-[36px] p-10 shadow-xl">

  <!-- Section heading -->
  <div class="text-center mb-10">

    <h2
      class="text-4xl font-bold text-blue-900"
      style="font-family: 'Caprasimo', cursive;"
    >
      What Students Say
    </h2>

    <p class="text-slate-500 mt-3">
      Real feedback from campus users using Evently
    </p>

  </div>

  <!-- TESTIMONIAL GRID -->
  <div class="grid md:grid-cols-3 gap-8">

    <!-- CARD 1 -->
    <div class="p-6 rounded-3xl bg-blue-50 border border-blue-100 shadow">

      <p class="text-slate-600 leading-7 mb-5">
        “Evently made it so easy to register for college events.
        Everything is smooth and well organized.”
      </p>

      <div class="flex items-center gap-3">

        <div class="w-10 h-10 rounded-full bg-blue-900 text-white flex items-center justify-center font-bold">
          S
        </div>

        <div>
          <h4 class="font-bold text-blue-900">Sujan KC</h4>
          <p class="text-sm text-slate-500">Student</p>
        </div>

      </div>

    </div>

    <!-- CARD 2 -->
    <div class="p-6 rounded-3xl bg-blue-50 border border-blue-100 shadow">

      <p class="text-slate-600 leading-7 mb-5">
        “As a club organizer, managing registrations and tickets
        became extremely simple with Evently.”
      </p>

      <div class="flex items-center gap-3">

        <div class="w-10 h-10 rounded-full bg-blue-900 text-white flex items-center justify-center font-bold">
          A
        </div>

        <div>
          <h4 class="font-bold text-blue-900">Aarav Sharma</h4>
          <p class="text-sm text-slate-500">Club Coordinator</p>
        </div>

      </div>

    </div>

    <!-- CARD 3 -->
    <div class="p-6 rounded-3xl bg-blue-50 border border-blue-100 shadow">

      <p class="text-slate-600 leading-7 mb-5">
        “The interface is clean and fast. Event updates and check-ins
        are now effortless.”
      </p>

      <div class="flex items-center gap-3">

        <div class="w-10 h-10 rounded-full bg-blue-900 text-white flex items-center justify-center font-bold">
          P
        </div>

        <div>
          <h4 class="font-bold text-blue-900">Priya Shrestha</h4>
          <p class="text-sm text-slate-500">Event Organizer</p>
        </div>

      </div>

    </div>

  </div>

</section>
       <footer class="w-500 bg-blue-900 p-6 mt-10 h-80 rounded-3xl">
        <div class="footer-content">
          <div class="flex justify-around">
            <div>
              <ul class="flex gap-2 font-mono flex-col mt-6">
                <li class="text-white hover:text-blue-300">
                  <a href="#" class="inline-flex gap-2">
                    <img src="./facebook.png" class="h-6" alt="" /><span
                      >Facebook</span
                    ></a
                  >
                </li>
                <li class="text-white hover:text-blue-300">
                   <a href="#" class="inline-flex gap-2">
                    <img src="./instagram.png" class="h-6" alt="" /><span
                      >Instagram</span
                    ></a
                </li>
                <li class="text-white hover:text-blue-300">
                   <a href="#" class="inline-flex gap-2">
                    <img src="./linkdin.png" class="h-6" alt="" /><span
                      >Linkdin</span
                    ></a
                </li>
                <li class="text-white hover:text-blue-300">
                  <a href="#" class="inline-flex gap-2">
                    <img src="./x.png" class="h-6" alt="" /><span
                      >X</span
                    ></a
                </li>
              </ul>
            </div>

            <div class="flex flex-col gap-3 w-[280px]">
              <h3 class="text-white font-bold text-sm font-mono">Contact Us</h3>

            <form action="/ContactServlet" method="post" class="flex flex-col gap-3">


  <input
    type="email"
    name="email"
    placeholder="Your Email"
    class="p-3 text-sm rounded-lg bg-blue-800 text-white placeholder-blue-300 border border-blue-700 focus:outline-none focus:border-blue-400"
    required
  />

  <textarea
    name="message"
    placeholder="Your Message"
    rows="2"
    class="p-4 text-sm rounded-lg bg-blue-800 text-white placeholder-blue-300 border border-blue-700 focus:outline-none focus:border-blue-400 resize-none"
    required
  ></textarea>

  <button
    type="submit"
    class="px-4 py-1.5 text-sm bg-white text-blue-900 font-bold rounded-lg hover:bg-blue-100 transition"
  >
    Send
  </button>

</form>
            </div>
            <div class="mt-6">
              <ul class="flex gap-2 flex-col">
                <li class="text-white font-mono hover:text-blue-300">
                  <a href="#" class="">Home</a>
                </li>
                <li class="text-white font-mono hover:text-blue-300">
                  <a href="#">About US</a>
                </li>
                <li class="text-white font-mono hover:text-blue-300">
                  <a href="#">Events</a>
                </li>
                <li class="text-white font-mono hover:text-blue-300">
                  <a href="#">Contact</a>
                </li>
              </ul>
            </div>
          </div>

          <hr class="mt-4"/>
          <div class="flex justify-between mt-9 text-white">
            <div>
              <p>Since 2025</p>
            </div>
            <div>
              <p>&copy;2026 Evently. All rights reserved.</p>
            </div>
          </div>
        </div>
      </footer>

    </div>
  </body>
</html>
