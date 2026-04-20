<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
            <input
                id="eventSearch"
                type="text"
                placeholder="Search event, date, or location"
                class="w-full sm:w-96 px-4 py-2.5 bg-gray-50 border border-gray-300 rounded-lg outline-none focus:ring-2 focus:ring-indigo-500"
            >
        </div>

        <c:if test="${param.success == '1'}">
            <div class="mb-4 rounded-md border border-green-200 bg-green-50 text-green-800 px-4 py-3 text-sm">
                You have joined the event successfully.
            </div>
        </c:if>
        <c:if test="${param.error == 'registration_failed'}">
            <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-700 px-4 py-3 text-sm">
                Oops, something went wrong while joining the event.
            </div>
        </c:if>
        <c:if test="${param.error == 'missing'}">
            <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-700 px-4 py-3 text-sm">
                Please fill all join details before submitting.
            </div>
        </c:if>
        <c:if test="${param.error == 'invalid_age'}">
            <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-700 px-4 py-3 text-sm">
                Please provide a valid age between 1 and 120.
            </div>
        </c:if>


        <div class="border border-gray-200 rounded-lg overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead>
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Location</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                    </tr>
                </thead>
                <tbody id="eventTableBody" class="bg-white divide-y divide-gray-200">
                    <c:forEach var="event" items="${events}">
                        <tr data-search="${event.title} ${event.location}">
                            <td class="px-6 py-4">${event.title}</td>
                            <td class="px-6 py-4">${event.location}</td>
                            <td class="px-6 py-4">
                                <button
                                    type="button"
                                    class="openJoinModal bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700"
                                    data-event-id="${event.id}"
                                    data-event-title="${event.title}">
                                    Join
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr id="noResultsRow" class="hidden">
                        <td colspan="3" class="px-6 py-4 text-sm text-gray-500">No events match your search.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<div id="joinModal" class="hidden fixed inset-0 z-40">
    <div id="joinModalBackdrop" class="absolute inset-0 bg-black/40"></div>
    <div class="relative min-h-screen flex items-center justify-center p-4">
        <section class="w-full max-w-xl bg-white rounded-lg border border-gray-200 p-5 sm:p-6 shadow-xl">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-lg font-medium text-indigo-700">Join Event</h2>
                <button id="closeJoinModal" type="button" class="text-slate-500 hover:text-indigo-700">Close</button>
            </div>
            <p class="text-sm text-gray-600 mb-4">Complete your details for: <span id="selectedEventTitle" class="font-medium"></span></p>
            <form method="post" action="${pageContext.request.contextPath}/joinEvent" class="space-y-4">
                <input id="modalEventId" type="hidden" name="eventId" />
                <input type="hidden" name="userId" value="${user.id}" />

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium mb-1" for="phone">Phone Number</label>
                        <input id="phone" name="phone" type="tel" required class="w-full rounded-md border border-blue-200 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-300" />
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1" for="age">Age</label>
                        <input id="age" name="age" type="number" min="1" max="120" required class="w-full rounded-md border border-blue-200 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-300" />
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium mb-1" for="preference">Preference</label>
                    <select id="preference" name="preference" required class="w-full rounded-md border border-blue-200 px-3 py-2 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-300">
                        <option value="" disabled selected>Select your preference</option>
                        <option value="Speaker">Speaker</option>
                        <option value="Attendee">Attendee</option>
                        <option value="Volunteer">Volunteer</option>
                        <option value="Networking">Networking</option>
                    </select>
                </div>

                <div class="flex justify-end gap-2">
                    <button id="cancelJoinModal" type="button" class="rounded-md border border-blue-200 px-4 py-2 text-sm text-slate-700 hover:bg-blue-50">Cancel</button>
                    <button type="submit" class="rounded-md bg-indigo-600 text-white px-4 py-2 text-sm hover:bg-indigo-700">Submit Join Request</button>
                </div>
            </form>
        </section>
    </div>
</div>

<script>
    const searchInput = document.getElementById("eventSearch");
    const rows = Array.from(document.querySelectorAll("#eventTableBody tr[data-search]"));
    const noResultsRow = document.getElementById("noResultsRow");
    const joinModal = document.getElementById("joinModal");
    const joinModalBackdrop = document.getElementById("joinModalBackdrop");
    const openJoinButtons = Array.from(document.querySelectorAll(".openJoinModal"));
    const closeJoinModalBtn = document.getElementById("closeJoinModal");
    const cancelJoinModalBtn = document.getElementById("cancelJoinModal");
    const modalEventIdInput = document.getElementById("modalEventId");
    const selectedEventTitle = document.getElementById("selectedEventTitle");

    function openJoinModal(eventId, eventTitle) {
        modalEventIdInput.value = eventId;
        selectedEventTitle.textContent = eventTitle;
        joinModal.classList.remove("hidden");
        document.body.classList.add("overflow-hidden");
    }

    function closeJoinModal() {
        joinModal.classList.add("hidden");
        document.body.classList.remove("overflow-hidden");
    }

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

    openJoinButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            openJoinModal(button.dataset.eventId, button.dataset.eventTitle);
        });
    });

    closeJoinModalBtn.addEventListener("click", closeJoinModal);
    cancelJoinModalBtn.addEventListener("click", closeJoinModal);
    joinModalBackdrop.addEventListener("click", closeJoinModal);

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape" && !joinModal.classList.contains("hidden")) {
            closeJoinModal();
        }
    });
</script>
</body>
</html>