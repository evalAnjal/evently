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
            <p class="text-gray-500">Welcome, ${user.username}</p>
        </div>
        <a href="index.jsp" class="text-sm text-indigo-600 hover:text-indigo-700">Logout</a>
    </div>
</header>

<main class="px-5 sm:px-8 py-6">
    <div class="bg-white rounded-xl border border-gray-200 p-4 sm:p-6">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-5">
            <h2 class="text-lg sm:text-xl font-semibold text-gray-800">Available Events</h2>
            <input
                id="eventSearch"
                type="text"
                placeholder="Search event, date, or location"
                class="w-full sm:w-96 px-4 py-2.5 bg-gray-50 border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-indigo-500"
            >
        </div>

        <div class="border border-gray-200 rounded-lg overflow-x-auto">
            <table class="w-full text-sm">
                <thead class="bg-gray-50 text-gray-700">
                <tr>
                    <th class="text-left font-semibold px-4 py-3">Event</th>
                    <th class="text-left font-semibold px-4 py-3">Date</th>
                    <th class="text-left font-semibold px-4 py-3">Location</th>
                    <th class="text-left font-semibold px-4 py-3">Action</th>
                </tr>
                </thead>
                <tbody id="eventTableBody" class="divide-y divide-gray-200 text-gray-700">
                <tr data-search="campus tech meetup 12 apr 10:00 am main hall">
                    <td class="px-4 py-3">Campus Tech Meetup</td>
                    <td class="px-4 py-3">12 Apr, 10:00 AM</td>
                    <td class="px-4 py-3">Main Hall</td>
                    <td class="px-4 py-3">
                        <form method="post" action="joinEvent">
                            <input type="hidden" name="eventId" value="101">
                            <button type="submit" class="bg-indigo-600 text-white px-3 py-1.5 rounded-md hover:bg-indigo-700 transition">Join</button>
                        </form>
                    </td>
                </tr>
                <tr data-search="community service drive 18 apr 2:00 pm student center">
                    <td class="px-4 py-3">Community Service Drive</td>
                    <td class="px-4 py-3">18 Apr, 2:00 PM</td>
                    <td class="px-4 py-3">Student Center</td>
                    <td class="px-4 py-3">
                        <form method="post" action="joinEvent">
                            <input type="hidden" name="eventId" value="102">
                            <button type="submit" class="bg-indigo-600 text-white px-3 py-1.5 rounded-md hover:bg-indigo-700 transition">Join</button>
                        </form>
                    </td>
                </tr>
                <tr data-search="sports and wellness day 25 apr 9:30 am sports ground">
                    <td class="px-4 py-3">Sports and Wellness Day</td>
                    <td class="px-4 py-3">25 Apr, 9:30 AM</td>
                    <td class="px-4 py-3">Sports Ground</td>
                    <td class="px-4 py-3">
                        <form method="post" action="joinEvent">
                            <input type="hidden" name="eventId" value="103">
                            <button type="submit" class="bg-indigo-600 text-white px-3 py-1.5 rounded-md hover:bg-indigo-700 transition">Join</button>
                        </form>
                    </td>
                </tr>
                <tr id="noResultsRow" class="hidden">
                    <td colspan="4" class="px-4 py-5 text-center text-gray-500">No events match your search.</td>
                </tr>
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