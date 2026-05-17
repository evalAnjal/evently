<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Home Page</title>
    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Caprasimo&family=Great+Vibes&display=swap"
      rel="stylesheet"
    />

    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        min-height: 100vh;
        background: linear-gradient(180deg, #eef2ff 0%, #f8fafc 100%);
        font-family: "Inter", system-ui, sans-serif;
        color: #0f172a;
      }

      .page-frame {
        max-width: 1180px;
        margin: 0 auto;
        padding: 28px 24px 64px;
      }

      nav {
        width: 100%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 28px;
        padding: 16px 24px;
        background: rgba(255, 255, 255, 0.96);
        border-radius: 52px;
        box-shadow: 0 24px 60px rgba(15, 23, 42, 0.08);
        backdrop-filter: blur(14px);
        height: 80px;
      }

      .menu ul {
        display: flex;
        gap: 32px;
        list-style: none;
      }

      a {
        color: rgb(15, 23, 42);
        font-family: "Inter", Arial, sans-serif;
        font-size: 18px;
        font-weight: 600;
        text-decoration: none;
        transition: color 0.25s ease;
      }

      a:hover {
        color: rgb(59, 130, 246);
      }

      .login button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 12px 26px;
        border-radius: 9999px;
        background-color: rgb(2, 55, 147);
        color: #ffffff;
        font-size: 17px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        transition:
          transform 0.2s ease,
          background-color 0.2s ease;
      }

      .login button:hover {
        background-color: rgb(37, 99, 235);
        transform: translateY(-1px);
      }

      .logo img {
        height: 140px;
        width: auto;
        display: block;
      }

      .hero-row {
        display: grid;
        gap: 42px;
        align-items: stretch;
        margin-top: 48px;
      }

      .hero {
        display: flex;
        flex-direction: column;
        gap: 24px;
        padding: 40px;
        background:
          radial-gradient(
            circle at top left,
            rgba(59, 130, 246, 0.14),
            transparent 34%
          ),
          rgba(255, 255, 255, 0.98);
        border-radius: 36px;
        box-shadow: 0 28px 60px rgba(15, 23, 42, 0.1);
      }

      .hero h1 {
        font-family: "Caprasimo", cursive;
        font-size: clamp(3rem, 5vw, 4.8rem);
        line-height: 0.95;
        color: rgb(15, 23, 42);
      }

      .hero p {
        color: #334155;
        font-size: 1.05rem;
        line-height: 1.85;
        max-width: 620px;
      }

      .hero-meta {
        display: grid;
        grid-template-columns: repeat(3, minmax(120px, 1fr));
        gap: 16px;
        margin-top: 16px;
      }

      .hero-meta .meta-card {
        padding: 20px;
        border-radius: 24px;
        background: #ffffff;
        border: 1px solid rgba(59, 130, 246, 0.12);
        box-shadow: 0 14px 32px rgba(15, 23, 42, 0.05);
      }

      .hero-meta .meta-card h3 {
        margin: 0 0 10px;
        font-size: 0.95rem;
        color: #475569;
      }

      .hero-meta .meta-card p {
        margin: 0;
        font-size: 1.35rem;
        font-weight: 700;
        color: rgb(15, 23, 42);
      }

      .mid {
        display: grid;
        grid-template-columns: repeat(2, minmax(260px, 1fr));
        gap: 24px;
        margin-top: 48px;
      }

      .feature-card {
        padding: 28px;
        border-radius: 28px;
        background: #ffffff;
        border: 1px solid rgba(59, 130, 246, 0.14);
        box-shadow: 0 18px 40px rgba(15, 23, 42, 0.06);
        display: grid;
        gap: 16px;
      }

      .feature-card img {
        width: 44px;
        height: 44px;
        object-fit: contain;
      }

      .feature-card h3 {
        margin: 0;
        font-size: 1.05rem;
        color: rgb(15, 23, 42);
      }

      .feature-card p {
        margin: 0;
        color: #475569;
        line-height: 1.75;
        font-size: 0.98rem;
      }

      .bottom-cta {
        display: flex;
        justify-content: center;
        margin-top: 52px;
      }

      .bottom-cta .join-btn {
        min-width: 220px;
      }

      @media (max-width: 1024px) {
        .mid {
          grid-template-columns: 1fr;
        }

        .hero-meta {
          grid-template-columns: 1fr;
        }
      }

      @media (max-width: 768px) {
        .page-frame {
          padding: 24px 18px 48px;
        }

        nav {
          flex-direction: column;
          gap: 20px;
          padding: 22px;
        }

        .menu ul {
          gap: 18px;
          flex-wrap: wrap;
          justify-content: center;
        }
      }
    </style>
  </head>
  <body>
    <div class="page-frame">
      <div class="content-top">
        <div class="w-full flex items-center justify-center mt-10">
          <nav>
            <div class="logo">
              <img src="../../../logoBlue.png" alt="Evently logo" />
            </div>
            <div class="menu font-mono">
              <ul>
                <li><a href="#" class="">Home</a></li>
                <li><a href="about.jsp">About US</a></li>
                <li><a href="member-dashboard.jsp">Events</a></li>
                <li><a href="#">Contact</a></li>

              </ul>
            </div>
            <div class="login">
              <button
                class="bg-indigo-700 text-slate-100 flex align-center justify-center border-none"
                type="button"
              >
               <a href="./index.jsp"> Log in</a>
              </button>
            </div>
          </nav>
        </div>
        <main class="hero-row">
          <div class="hero">
            <h1 class="caprasimo-regulars" style="color: rgb(2, 55, 147)">
              Evently
            </h1>
            <p class="hero-copy">
              Discover and manage events with a clean campus-first interface.
              Evently helps organizers publish event details, sell tickets, and
              keep every attendee connected.
            </p>
            <button
              style="
                padding: 10px;
                display: flex;
                width: 120px;
                border: 2px solid rgb(2, 55, 147);
                justify-content: center;
                border-radius: 20px;
                color: rgb(2, 55, 147);
              "
            >
              <a href="">Join Now</a>
            </button>

            <div class="hero-meta">
              <div class="meta-card">
                <h3>Designed for campuses</h3>
                <p>100%</p>
              </div>
              <div class="meta-card">
                <h3>Fast setup</h3>
                <p>Minutes</p>
              </div>
              <div class="meta-card">
                <h3>Events supported</h3>
                <p>1000+</p>
              </div>
            </div>
          </div>
        </main>
      </div>
      <div class="mid">
        <div class="feature-card">
          <img src="./branding.png" alt="Branding icon" />
          <div>
            <h3 class="font-bold">Full branding</h3>
            <p>
              Keep your campus identity with custom event designs, colors, and
              messaging.
            </p>
          </div>
        </div>

        <div class="feature-card">
          <img src="./tickets.png" alt="Ticketing icon" />
          <div>
            <h3 class="font-bold">Ticketing</h3>
            <p>
              Sell tickets and track registrations from one
              place.
            </p>
          </div>
        </div>

        <div class="feature-card">
          <img src="./scalable.png" alt="Scalable icon" />
          <div>
            <h3 class="font-bold">Scalable for all events</h3>
            <p>
              From student clubs to campus-wide festivals, Evently scales with
              your needs.
            </p>
          </div>
        </div>

        <div class="feature-card">
          <img src="./checkin.png" alt="Check in icon" />
          <div>
            <h3 class="font-bold">Fast check in</h3>
            <p>
              Speed attendee entry with simple mobile check-in and QR support.
            </p>
          </div>
        </div>
      </div>
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
<form action="${pageContext.request.contextPath}/ContactServlet" method="post" class="flex flex-col gap-3">

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
