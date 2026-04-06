<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Login | Evently</title>
</head>
<body class="bg-slate-100 h-screen flex items-center justify-center">
<div class="bg-white p-8 rounded-2xl shadow-xl w-full max-w-md">
    <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-indigo-600">Evently</h1>
        <p class="text-gray-500">Welcome back! Please login.</p>
    </div>

    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (successMessage != null) { %>
        <div class="mb-4 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 text-sm"><%= successMessage %></div>
    <% } %>
    <% if (errorMessage != null) { %>
        <div class="mb-4 rounded-lg bg-red-50 border border-red-200 text-red-700 px-4 py-3 text-sm"><%= errorMessage %></div>
    <% } %>

    <form action="loginProcess" method="POST" class="space-y-6">
        <div>
            <label class="block text-sm font-medium text-gray-700">Email Address</label>
            <input type="email" name="email" required class="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">Password</label>
            <input type="password" name="password" required class="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
        </div>
        <button type="submit" class="w-full bg-indigo-600 text-white py-3 rounded-lg font-semibold hover:bg-indigo-700 shadow-lg shadow-indigo-200 transition">
            Sign In
        </button>
        <p>New User? Click <a href="/register.jsp" style="color: rgb(46, 46, 216)">here</a> to Be a member</p>
    </form>
</div>
</body>
</html>