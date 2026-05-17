<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Home Page</title>
    <link href="/src/style.css" rel="stylesheet" />
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
        height: 0;
      }
      body {
        padding: 50px;
        min-height: 100vh;
        background-color: #f5f5dc;
      }

      nav {
        width: 90%;
        padding: 15px;
        display: flex;
        justify-content: space-around;
        background-color: rgb(255, 255, 255);
        margin: 50px;
        height: auto;
        padding: 37px;
        border-radius: 30px;
        align-items: center;
        box-shadow: 5px 5px 20px rgb(122, 121, 121);
      }
      .menu ul {
        margin-top: -10px;
        display: flex;
        gap: 40px;
        list-style-type: none;
      }
      a {
        color: rgb(1, 50, 122);
        font-family: Arial, Helvetica, sans-serif;
        font-size: 18px;
        text-align: center;
        text-decoration: none;
        font-weight: bold;
        transition: all 1s;
      }
      a:hover {
        text-decoration: underline;
        transition: all 1s;
        text-decoration-color: rgb(1, 50, 122);
      }
      .login button {
        display: flex;
        align-content: center;
        text-align: center;
        margin-top: -12px;
        padding: 5px;
        height: 35px;
        width: 80px;
        text-align: center;
        vertical-align: middle;
        border-radius: 20px;
        /* border: 3px solid rgb(1, 50, 122);    */

        /* margin-top: 60px; */
        align-items: center;
        justify-content: center;
        font-size: 18px;
        font-weight: bolder;
        transition: all ease-in-out 0.9;
      }

      .login button:hover {
        background-color: #bcdaf046;
        color: #1a1a1a;
        transition: all ease-in-out 0.9;
      }
      .caprasimo-regular {
        font-family: "Caprasimo", serif;
        font-weight: 200;
        font-style: normal;
        font-size: 60px;
      }

      .hero {
        height: 500px;
        display: flex;
        flex-direction: column;
        align-items: start;
        justify-content: center;
        font-family: Arial, Helvetica, sans-serif;
        /* font-size: 30px; */
        margin-left: 50px;
        font-weight: bolder;
        color: rgb(1, 50, 122);
      }
      .join-btn {
        padding: 10px;
        height: 50px;
        width: 150px;
        border-radius: 20px;
        border: 3px solid rgb(1, 50, 122);
        margin-top: 60px;
        align-items: center;
        font-size: 20px;
        font-weight: bolder;
      }
    </style>
  </head>
  <body class="bg-slate-100">
    <div class="w-full flex items-center justify-center mt-10 bg-white">
      <nav>
        <div class="logo ml-0 relative left--5 botton--2">
          <img
            src="../../../logoBlue.png"
            alt=""
            style="height: 120px; width: 130px; margin-top: -55px"
          />
        </div>
        <div class="menu font-mono">
          <ul>
            <li><a href="#" class="">Home</a></li>
            <li><a href="#">About US</a></li>
            <li><a href="#">Events</a></li>
          </ul>
        </div>
        <div class="login">
          <button
            class="bg-indigo-700 text-slate-100 flex align-center justify-center border-none"
            type="submit  "
          >
            Log in
          </button>
        </div>
      </nav>
    </div>
    <div class="hero">
      <h1 class="caprasimo-regular mt-20">Evently,</h1>
      <p
        style="margin-top: 80px; width: 550px; color: #1a1a1a"
        class="mb-5 mt-5"
      >
        Your campus, organized. Evently brings all campus events into one place
        - register, explore, and manage events with ease
      </p>
      <button
        class="join-btn bg-indigo-700 text-slate-100 flex align-center justify-center border-none"
      >
        Join Now
      </button>
    </div>
  </body>
</html>
