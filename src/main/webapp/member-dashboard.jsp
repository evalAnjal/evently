<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Dashboard | Evently</title>
</head>
<body class="bg-slate-100 min-h-screen">


<header class="bg-white border-b border-gray-200 px-5 sm:px-8 py-4">
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
            <h1 class="text-2xl font-bold text-indigo-600">Evently Dashboard</h1>
            <p class="text-gray-500">Welcome, ${user.id}</p>

        </div>
        <a href="<%= request.getContextPath() %>/logout" class="text-sm text-indigo-600 hover:text-indigo-700">Logout</a>
    </div>
</header>


<main class="px-5 sm:px-8 py-6">
    <div class="bg-white rounded-xl border border-gray-200 p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-5">
            <h2 class="text-lg sm:text-xl font-semibold text-gray-800">Available Events</h2>
            <!--Registration Failed Message from Backend

            http://localhost:8080/Member-dashboard?error=registration_failed

            -->
            <% String errorMessage = request.getParameter("error"); %>
            <% if ("registration_failed".equals(errorMessage)) { %>
                <div class="rounded-md bg-red-50 border border-red-200 text-red-700 px-4 py-3 text-sm">
                   Oppss..! Something Went Wrong!!
                </div>
            <% } %>

            
        
            <input
                id="eventSearch"
                type="text"
                placeholder="Search event, date, or location"
                class="w-full sm:w-96 px-4 py-2.5 bg-gray-50 border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-indigo-500"
            >
        </div>

        <div class="border border-gray-200 rounded-lg overflow-x-auto">
         <%@ taglib prefix="c" uri="jakarta.tags.core" %>

<table class="min-w-full divide-y divide-gray-200">
    <thead>
        <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Location</th>
        </tr>
    </thead>
    <tbody class="bg-white divide-y divide-gray-200">
        <c:forEach var="event" items="${events}">
            <tr>
                <td class="px-6 py-4">${event.title}</td>
                <td class="px-6 py-4">${event.location}</td>
                <td class="px-6 py-4">
                    <form action="/joinEvent" method="post">
                        <input type="hidden" name="eventId" value = "${event.id}">
                        <input type="hidden" name="userId" value = "${user.id}">

                    <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded">Join</button>
                </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
        </div>
    </div>
</main>

<script>
    const searchInput = document.getElementById("eventSearch");
    const rows = Array.from(document.querySelectorAll("#eventTableBody tr[data-search]"));
    const noResultsRow = document.getElementById("noResultsRow");

    searchInput.addEventListener("input", function () {
        const query = searchInput.value.trim().toLowerCase();
        let visibleCount = 0;

        rows.forEach(function (row) {
            const searchableText = row.getAttribute("data-search") || "";
            const show = searchableText.includes(query);
            row.classList.toggle("hidden", !show);
            if (show) visibleCount += 1;
        });

        noResultsRow.classList.toggle("hidden", visibleCount !== 0);
    });
</script>
</body>
</html>