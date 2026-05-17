<%
    com.eventmgmt.demo.model.User loggedInUser =
            (com.eventmgmt.demo.model.User) session.getAttribute("user");
    if (loggedInUser != null) {
        if ("ADMIN".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/Member-dashboard");
        }
        return;
    }
%>
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
        <p class="text-gray-500">Be a Evently User</p>
    </div>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="mb-4 rounded-lg bg-red-50 border border-red-200 text-red-700 px-4 py-3 text-sm"><%= errorMessage %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/registerProcess" method="POST" class="space-y-6">
        <div>
            <label class="block text-sm font-medium text-gray-700">Account Type</label>
            <select id="accountType" name="accountType" class="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
                <option value="MEMBER" selected>Member</option>
                <option value="ORGANISER">Organisation / Event Organiser</option>
            </select>
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">Full Name</label>
            <input type="text" name="username" required class="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">District</label>
            <select name="district" required class="mt-1 block w-full px-4 py-3 bg-white border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
                <option value="" disabled selected>Select district</option>
                <option value="morang">Morang</option>
                <option value="sunsari">Sunsari</option>
            </select>
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">Email Address</label>
            <input type="email" name="email" required class="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">Password</label>
            <input type="password" name="pass" required class="mt-1 block w-full px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
        </div>

        <div id="organiserSection" class="hidden rounded-lg border border-indigo-200 bg-indigo-50 p-4 space-y-3">
            <p class="text-sm font-medium text-indigo-800">Organisation Details (requires SUPER_ADMIN approval)</p>
            <div>
                <label class="block text-sm font-medium text-gray-700">Organisation Name</label>
                <input id="orgName" type="text" name="orgName" class="mt-1 block w-full px-4 py-2.5 bg-white border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Organisation Phone</label>
                <input id="orgPhone" type="text" name="orgPhone" class="mt-1 block w-full px-4 py-2.5 bg-white border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Organisation Address</label>
                <textarea id="orgAddress" name="orgAddress" rows="2" class="mt-1 block w-full px-4 py-2.5 bg-white border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 outline-none transition"></textarea>
            </div>
        </div>
        <button type="submit" class="w-full bg-indigo-600 text-white py-3 rounded-lg font-semibold hover:bg-indigo-700 shadow-lg shadow-indigo-200 transition">
            Sign Up
        </button>
        <p>Already A member? Click <a href="<%= request.getContextPath() %>/index.jsp" class="text-indigo-600">here</a> to Login</p>
       

    </form>
</div>
<script>
    const accountType = document.getElementById("accountType");
    const organiserSection = document.getElementById("organiserSection");
    const orgName = document.getElementById("orgName");
    const orgAddress = document.getElementById("orgAddress");

    function syncRegistrationMode() {
        const isOrg = accountType.value === "ORGANISER";
        organiserSection.classList.toggle("hidden", !isOrg);
        orgName.required = isOrg;
        orgAddress.required = isOrg;
    }

    accountType.addEventListener("change", syncRegistrationMode);
    syncRegistrationMode();
</script>
</body>
</html>