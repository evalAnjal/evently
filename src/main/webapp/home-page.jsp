<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Home Page</title>
    <link href="/src/style.css" rel="stylesheet" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Caprasimo&family=Great+Vibes&display=swap"
      rel="stylesheet"
    />

    <style>
      * {
        padding: 0;
        margin: 0;
        height: 0;
      }
      body {
        height: 100vh;
        background-color: #95bfe96e;
      }

      nav {
        padding: 15px;
        display: flex;
        justify-content: space-around;
        background-color: rgb(255, 255, 255);
        margin: 50px;
        height: 35px;
        border-radius: 30px;
        align-items: center;
      }
      .menu ul {
        margin-top: -10px;
        display: flex;
        gap: 40px;
        list-style-type: none;
      }
      a {
        text-align: center;
        text-decoration: none;
      }
      .login button {
        margin-top: -10px;
        padding: 10px;
        height: 30px;
        width: 70px;
        text-align: center;
        vertical-align: middle;
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
  <body>
    <div class="container">
      <div class="content">
        <nav>
          <div class="logo">
            <img
              src="../../../logoBlue.png"
              alt=""
              style="height: 30px; width: 40px; margin-top: -10px"
            />
          </div>
          <div class="menu">
            <ul>
              <li><a href="#">Home</a></li>
              <li><a href="#">About US</a></li>
              <li><a href="#">Events</a></li>
            </ul>
          </div>
          <div class="login">
            <button type="submit">Log in</button>
          </div>
        </nav>
        <div class="hero">
          <h1 class="caprasimo-regular">Evently!</h1>
          <p style="margin-top: 80px; width: 550px; color: #1a1a1a">
            Your campus, organized. Evently brings all campus events into one
            place - register, explore, and manage events with ease
          </p>
          <button class="join-btn">Join Now</button>
        </div>
      </div>
    </div>
  </body>
</html>
