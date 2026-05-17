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
      body {
        background: linear-gradient(180deg, #eef2ff 0%, #f8fafc 100%);
        font-family: "Inter", sans-serif;
        color: #0f172a;
      }

      nav {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(12px);
        box-shadow: 0 24px 60px rgba(15, 23, 42, 0.08);
        border-radius: 50px;
      }

      .card {
        box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
      }
    </style>
  </head>

  <body>
    <div class="max-w-[1180px] mx-auto px-6 py-8">
      <!-- NAVBAR -->
      <div class="flex justify-center mt-10">
        <nav class="w-full flex justify-between items-center px-8 py-4">
          <img src="../../../logoBlue.png" class="h-24" />

          <ul class="flex gap-8 font-semibold text-slate-700">
            <li>
              <a href="home-page.jsp" class="hover:text-blue-600">Home</a>
            </li>
            <li><a href="about.jsp" class="text-blue-600">About</a></li>
            <li><a href="#" class="hover:text-blue-600">Events</a></li>
            <li><a href="#" class="hover:text-blue-600">Contact</a></li>
          </ul>

          <button
            class="bg-blue-900 text-white px-6 py-2 rounded-full font-bold hover:bg-blue-700"
          >
            Login
          </button>
        </nav>
      </div>

      <!-- HERO -->
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

      <!-- ABOUT SECTION (NEW LAYOUT) -->
      <section class="mt-12 grid lg:grid-cols-3 gap-8">
        <!-- LEFT INFO -->
        <div class="lg:col-span-2 bg-white p-10 rounded-[36px] card">
          <h2 class="text-3xl font-bold text-blue-900 mb-6">
            Why Choose Evently?
          </h2>

          <p class="text-slate-600 leading-8 mb-8">
            Evently is built for students who want a simple and powerful way to
            manage campus events. It brings all event tools into one platform so
            organizers can focus on experience rather than complexity.
          </p>
        </div>
      </section>
    </div>
  </body>
</html>
