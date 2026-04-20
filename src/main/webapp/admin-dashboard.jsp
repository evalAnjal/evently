<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Admin Dashboard | Evently</title>
</head>
<body class="bg-blue-50 text-slate-900 min-h-screen">
<main class="max-w-6xl mx-auto px-4 py-8 sm:py-10">
    <header class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between mb-6">
        <div>
            <h1 class="text-2xl font-semibold">Evently Admin Dashboard</h1>
            <p class="text-sm text-slate-600 mt-1">Manage events, participation, and registrations</p>
			<P class="text-sm text-gray-600 mt-1" >${user.role} | ${user.email} | ${user.username} </P>
        </div>
        <div class="flex items-center gap-3">
            <button id="openCreateModal" type="button" class="rounded-md bg-indigo-600 text-white px-4 py-2 text-sm hover:bg-indigo-700">
                Create New Event
            </button>
            <a href="${pageContext.request.contextPath}/logout" class="text-sm text-indigo-700 hover:text-indigo-900">Logout</a>
        </div>
    </header>

    <c:if test="${param.success == '1'}">
        <div class="mb-4 rounded-md border border-green-200 bg-green-50 text-green-800 px-4 py-3 text-sm">
            Event created successfully.
        </div>
    </c:if>
    <c:if test="${param.error == 'missing'}">
        <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-800 px-4 py-3 text-sm">
            Please fill all required fields.
        </div>
    </c:if>
    <c:if test="${param.error == 'date'}">
        <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-800 px-4 py-3 text-sm">
            Invalid date format.
        </div>
    </c:if>
    <c:if test="${param.error == 'failed'}">
        <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-800 px-4 py-3 text-sm">
            Event could not be created. Please try again.
        </div>
    </c:if>

    <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <article class="bg-white border border-blue-100 rounded-lg p-4 shadow-sm">
            <p class="text-sm text-slate-500">Total Events</p>
            <p class="text-2xl font-semibold mt-1">${totalEvents}</p>
        </article>
        <article class="bg-white border border-blue-100 rounded-lg p-4 shadow-sm">
            <p class="text-sm text-slate-500">Approved Events</p>
            <p class="text-2xl font-semibold mt-1">${approvedEvents}</p>
        </article>
        <article class="bg-white border border-blue-100 rounded-lg p-4 shadow-sm">
            <p class="text-sm text-slate-500">Members</p>
            <p class="text-2xl font-semibold mt-1">${totalMembers}</p>
        </article>
        <article class="bg-white border border-blue-100 rounded-lg p-4 shadow-sm">
            <p class="text-sm text-slate-500">Total Registrations</p>
            <p class="text-2xl font-semibold mt-1">${totalRegistrations}</p>
        </article>
    </section>

    <section class="bg-white border border-blue-100 rounded-lg p-5 sm:p-6 shadow-sm">
        <div class="flex items-center justify-between mb-3">
            <h2 class="text-lg font-medium text-indigo-700">Event Overview</h2>
            <span class="text-xs text-slate-500">Per-event participation and registrations</span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-sm">
                <thead>
                <tr class="text-left border-b border-blue-100 bg-blue-50/60">
                    <th class="py-2 pr-4">Title</th>
                    <th class="py-2 pr-4">Date</th>
                    <th class="py-2 pr-4">Location</th>
                    <th class="py-2 pr-4">Participants</th>
                    <th class="py-2 pr-4">Registrations</th>
                    <th class="py-2 pr-4">Status</th>
                    <th class="py-2">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="event" items="${events}">
                    <tr class="border-b border-blue-50 hover:bg-blue-50/40">
                        <td class="py-2 pr-4">${event.title}</td>
                        <td class="py-2 pr-4 whitespace-nowrap">
                            <fmt:formatDate value="${event.eventDate}" pattern="yyyy-MM-dd HH:mm" />
                        </td>
                        <td class="py-2 pr-4">${event.location}</td>
                        <td class="py-2 pr-4">${participantCounts[event.id] == null ? 0 : participantCounts[event.id]}</td>
                        <td class="py-2 pr-4">${registrationCounts[event.id] == null ? 0 : registrationCounts[event.id]}</td>
                        <td class="py-2 pr-4">${event.status}</td>
                        <td class="py-2">
                            <a
                                href="${pageContext.request.contextPath}/admin-dashboard?eventId=${event.id}#memberDetails"
                                class="inline-flex items-center rounded-md border border-indigo-200 px-3 py-1.5 text-xs font-medium text-indigo-700 hover:bg-indigo-50">
                                View Details
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty events}">
                    <tr>
                        <td colspan="7" class="py-3 text-slate-500">No events to show.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>

    <c:if test="${selectedEventId != null}">
        <section id="memberDetails" class="mt-6 bg-white border border-blue-100 rounded-lg p-5 sm:p-6 shadow-sm">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mb-3">
                <h2 class="text-lg font-medium text-indigo-700">
                    Joined Members: ${selectedEvent.title}
                </h2>
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="text-xs text-indigo-700 hover:text-indigo-900">Clear</a>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-sm">
                    <thead>
                    <tr class="text-left border-b border-blue-100 bg-blue-50/60">
                        <th class="py-2 pr-4">Member ID</th>
                        <th class="py-2 pr-4">Username</th>
                        <th class="py-2 pr-4">Email</th>
                        <th class="py-2 pr-4">Phone</th>
                        <th class="py-2 pr-4">Age</th>
                        <th class="py-2">Preference</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="member" items="${selectedEventMembers}">
                        <tr class="border-b border-blue-50 hover:bg-blue-50/40">
                            <td class="py-2 pr-4">${member.userId}</td>
                            <td class="py-2 pr-4">${member.username}</td>
                            <td class="py-2 pr-4">${member.email}</td>
                            <td class="py-2 pr-4">${member.phone}</td>
                            <td class="py-2 pr-4">${member.age}</td>
                            <td class="py-2">${member.preference}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty selectedEventMembers}">
                        <tr>
                            <td colspan="6" class="py-3 text-slate-500">No members have joined this event yet.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </c:if>

    <div id="createModal" class="hidden fixed inset-0 z-40">
        <div id="modalBackdrop" class="absolute inset-0 bg-black/40"></div>
        <div class="relative min-h-screen flex items-center justify-center p-4">
            <section class="w-full max-w-xl bg-white rounded-lg border border-blue-100 p-5 sm:p-6 shadow-xl">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-lg font-medium text-indigo-700">Create New Event</h2>
                    <button id="closeCreateModal" type="button" class="text-slate-500 hover:text-indigo-700">Close</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/addEvent" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium mb-1" for="title">Title</label>
                        <input id="title" name="title" type="text" required class="w-full rounded-md border border-blue-200 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-300" />
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1" for="description">Description</label>
                        <textarea id="description" name="description" rows="4" class="w-full rounded-md border border-blue-200 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-300"></textarea>
                    </div>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium mb-1" for="location">Location</label>
                            <input id="location" name="location" type="text" required class="w-full rounded-md border border-blue-200 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-300" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1" for="eventDate">Date and Time</label>
                            <input id="eventDate" name="eventDate" type="datetime-local" required class="w-full rounded-md border border-blue-200 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-300" />
                        </div>
                    </div>
                    <div class="flex justify-end gap-2">
                        <button id="cancelCreateModal" type="button" class="rounded-md border border-blue-200 px-4 py-2 text-sm text-slate-700 hover:bg-blue-50">Cancel</button>
                        <button type="submit" class="rounded-md bg-indigo-600 text-white px-4 py-2 text-sm hover:bg-indigo-700">Create Event</button>
                    </div>
                </form>
            </section>
        </div>
    </div>
</main>

<script>
    const modal = document.getElementById("createModal");
    const openBtn = document.getElementById("openCreateModal");
    const closeBtn = document.getElementById("closeCreateModal");
    const cancelBtn = document.getElementById("cancelCreateModal");
    const backdrop = document.getElementById("modalBackdrop");

    function openModal() {
        modal.classList.remove("hidden");
        document.body.classList.add("overflow-hidden");
    }

    function closeModal() {
        modal.classList.add("hidden");
        document.body.classList.remove("overflow-hidden");
    }

    openBtn.addEventListener("click", openModal);
    closeBtn.addEventListener("click", closeModal);
    cancelBtn.addEventListener("click", closeModal);
    backdrop.addEventListener("click", closeModal);
    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape" && !modal.classList.contains("hidden")) {
            closeModal();
        }
    });
</script>
</body>
</html>
