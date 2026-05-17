<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("nowMillis", System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Events | Evently</title>
</head>
<body class="bg-gray-50 min-h-screen">

<!-- Header -->
<header class="bg-white border-b border-gray-200">
    <div class="max-w-7xl mx-auto px-5 sm:px-8 py-4">
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Evently</h1>
                <p class="text-sm text-gray-500 mt-1">Discover and join events</p>
            </div>
            <div class="text-right">
                <p class="text-sm text-gray-600">Welcome, <span class="font-semibold">${user.username}</span></p>
                <a href="<%= request.getContextPath() %>/logout" class="text-sm text-indigo-600 hover:text-indigo-700 font-medium">Logout</a>
            </div>
        </div>
    </div>
</header>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-5 sm:px-8 py-8">
    
    <!-- Alerts -->
    <c:if test="${param.success == '1'}">
        <div class="mb-6 rounded-lg border border-green-300 bg-green-50 text-green-900 px-4 py-3 text-sm">
             You have joined the event successfully.
        </div>
    </c:if>
    <c:if test="${param.error == 'registration_failed'}">
        <div class="mb-6 rounded-lg border border-red-300 bg-red-50 text-red-900 px-4 py-3 text-sm">
            Something went wrong. This event may have duplicate registration.
        </div>
    </c:if>
    <c:if test="${param.error == 'missing'}">
        <div class="mb-6 rounded-lg border border-red-300 bg-red-50 text-red-900 px-4 py-3 text-sm">
            Please fill all required fields.
        </div>
    </c:if>
    <c:if test="${param.error == 'full'}">
        <div class="mb-6 rounded-lg border border-red-300 bg-red-50 text-red-900 px-4 py-3 text-sm">
            This event is full and cannot accept more registrations.
        </div>
    </c:if>
    <c:if test="${param.error == 'invalid_age'}">
        <div class="mb-6 rounded-lg border border-red-300 bg-red-50 text-red-900 px-4 py-3 text-sm">
            Age must be between 1 and 120.
        </div>
    </c:if>

    <!-- Filter & Search Section -->
    <div class="mb-8">
        <div class="flex items-center justify-end mb-3">
            <c:choose>
                <c:when test="${showPast}">
                    <a href="${pageContext.request.contextPath}/Member-dashboard" class="text-sm text-indigo-600 hover:underline">← Back to upcoming events</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/Member-dashboard?view=past" class="text-sm text-indigo-600 hover:underline">View past events you joined</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="flex flex-col sm:flex-row gap-4 items-start sm:items-end">
            <div class="flex-1">
                <label class="block text-sm font-medium text-gray-700 mb-2">Search events</label>
                <input
                    id="eventSearch"
                    type="text"
                    placeholder="Type event name, location..."
                    class="w-full px-4 py-2.5 bg-white border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                >
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Sort by</label>
                <select id="sortSelect" class="px-4 py-2.5 bg-white border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500">
                    <option value="date-asc">Upcoming First</option>
                    <option value="date-desc">Latest First</option>
                    <option value="title">Event Name (A-Z)</option>
                </select>
            </div>
        </div>
        <p class="text-xs text-gray-500 mt-2">
            <span id="eventCount">0</span> event<span id="eventCountPlural">s</span> available
        </p>
    </div>

    <!-- Events Grid -->
    <div id="eventsContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        <c:forEach var="event" items="${events}">
            <div class="eventCard bg-white rounded-lg border border-gray-200 overflow-hidden hover:shadow-md transition-shadow" 
                 data-search="${event.title} ${event.location}" 
                 data-date="${event.eventDate.time}"
                 data-title="${event.title}">
                
                <!-- Card Header with Status -->
                <div class="px-5 py-4 border-b border-gray-100">
                    <div class="flex items-start justify-between gap-2 mb-2">
                        <h3 class="text-lg font-semibold text-gray-900 flex-1 line-clamp-2">${event.title}</h3>
                        <c:choose>
                            <c:when test="${event.eventDate.time lt nowMillis}">
                                <span class="text-xs font-semibold px-2.5 py-1 bg-gray-100 text-gray-600 rounded">Past</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-xs font-semibold px-2.5 py-1 bg-indigo-100 text-indigo-700 rounded">Upcoming</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Card Body -->
                <div class="px-5 py-4 space-y-3">
                    
                    <!-- Description -->
                    <p class="text-sm text-gray-600 line-clamp-2">
                        ${empty event.description ? 'Join this upcoming event and connect with others.' : event.description}
                    </p>

                    <!-- Event Details Row 1 -->
                    <div class="space-y-2">
                        <div class="flex items-center gap-2 text-sm text-gray-700">
                            <span class="text-base">📍</span>
                            <span>${event.location}</span>
                        </div>
                        <div class="flex items-center gap-2 text-sm text-gray-700">
                            <span class="text-base">📅</span>
                            <span>
                               <!-- not register if event date is in the past -->
                             
                                <fmt:formatDate value="${event.eventDate}" pattern="MMM dd, yyyy" />&nbsp;
                                <fmt:formatDate value="${event.eventDate}" pattern="hh:mm a" />
                            </span>
                        </div>
                        <div class="flex items-center gap-2 text-sm text-gray-700">
                            <span class="text-base">👥</span>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty event.capacity}">${event.capacity} seats</c:when>
                                    <c:otherwise>Unlimited seats</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-xs text-gray-500">Not registered yet</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Card Footer - Action Button -->
                <div class="px-5 py-4 border-t border-gray-100 bg-gray-50">
                    <c:choose>
                        <c:when test="${joinedIds != null && joinedIds.contains(event.id)}">
                            <button
                                type="button"
                                class="w-full bg-gray-200 text-gray-600 py-2.5 rounded-lg font-medium cursor-not-allowed text-sm"
                                disabled>
                                Registered
                            </button>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${!showPast}">
                                <button
                                    type="button"
                                    class="openJoinModal w-full bg-indigo-600 text-white py-2.5 rounded-lg font-medium hover:bg-indigo-700 transition-colors text-sm"
                                    data-event-id="${event.id}"
                                    data-event-title="${event.title}"
                                    data-event-location="${event.location}">
                                    Register Now
                                </button>
                            </c:if>
                            <c:if test="${showPast}">
                                <div class="text-sm text-gray-500 text-center">Event ended</div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- No Results Message -->
    <div id="noResultsMessage" class="hidden text-center py-16">
        <div class="text-gray-400 text-5xl mb-4">🔍</div>
        <h3 class="text-lg font-semibold text-gray-900 mb-2">No events found</h3>
        <p class="text-gray-600 text-sm">Try adjusting your search or check back later for new events.</p>
    </div>

</main>

<div id="joinModal" class="hidden fixed inset-0 z-50 bg-black/30 flex items-center justify-center p-4">
    <div class="bg-white rounded-xl border border-gray-200 w-full max-w-2xl max-h-[90vh] overflow-y-auto shadow-xl">
        
        <!-- Modal Header -->
        <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <div>
                <h2 class="text-xl font-semibold text-gray-900">Register for Event</h2>
                <p id="modalEventName" class="text-sm text-gray-600 mt-1"></p>
            </div>
            <button id="closeJoinModal" type="button" class="text-gray-400 hover:text-gray-600 text-2xl leading-none">&times;</button>
        </div>

        <!-- Modal Body -->
        <div class="px-6 py-6">
            <form method="post" action="${pageContext.request.contextPath}/joinEvent" class="space-y-5">
                <input id="modalEventId" type="hidden" name="eventId" />
                <input type="hidden" name="userId" value="${user.id}" />

                <!-- Your Details Section -->
                <div>
                    <h3 class="text-sm font-semibold text-gray-900 mb-4">Your Details</h3>
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1.5" for="phone">Phone Number</label>
                            <input id="phone" name="phone" type="tel" placeholder="e.g., +1 234-567-8900" required 
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent" />
                            <p class="text-xs text-gray-500 mt-1">We'll use this to contact you about the event</p>
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1.5" for="age">Age</label>
                                <input id="age" name="age" type="number" min="1" max="120" placeholder="e.g., 25" required 
                                       class="w-full px-4 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent" />
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1.5" for="preference">Your Role</label>
                                <select id="preference" name="preference" required 
                                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg text-sm bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                                    <option value="" disabled selected>Select role</option>
                                    <option value="Speaker">🎤 Speaker</option>
                                    <option value="Attendee">👥 Attendee</option>
                                    <option value="Volunteer">🤝 Volunteer</option>
                                    <option value="Networking">💼 Networking</option>
                                </select>
                                <p class="text-xs text-gray-500 mt-1">How do you want to participate?</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Divider -->
                <hr class="border-gray-200">

                <!-- Terms -->
                <div class="bg-gray-50 rounded-lg p-3.5">
                    <p class="text-xs text-gray-600">
                        By registering, you agree to receive event updates and communications at the provided contact information.
                    </p>
                </div>

                <!-- Actions -->
                <div class="flex gap-3 justify-end pt-2">
                    <button id="cancelJoinModal" type="button" class="px-5 py-2.5 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors">
                        Cancel
                    </button>
                    <button type="submit" class="px-6 py-2.5 bg-indigo-600 text-white rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors">
                        Confirm Registration
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // ========== DOM References ==========
    const searchInput = document.getElementById("eventSearch");
    const sortSelect = document.getElementById("sortSelect");
    const joinModal = document.getElementById("joinModal");
    const eventsContainer = document.getElementById("eventsContainer");
    const noResultsMessage = document.getElementById("noResultsMessage");
    const eventCountSpan = document.getElementById("eventCount");
    const eventCountPluralSpan = document.getElementById("eventCountPlural");
    
    const openJoinButtons = Array.from(document.querySelectorAll(".openJoinModal"));
    const closeModalBtn = document.getElementById("closeJoinModal");
    const cancelModalBtn = document.getElementById("cancelJoinModal");
    const modalEventIdInput = document.getElementById("modalEventId");
    const modalEventName = document.getElementById("modalEventName");
    const phoneInput = document.getElementById("phone");
    const ageInput = document.getElementById("age");
    const preferenceSelect = document.getElementById("preference");

    // ========== Modal Functions ==========
    function openJoinModal(eventId, eventTitle, eventLocation) {
        modalEventIdInput.value = eventId;
        modalEventName.innerHTML = `<span class="font-semibold">${eventTitle}</span> • ${eventLocation}`;
        
        // Reset form
        phoneInput.value = "";
        ageInput.value = "";
        preferenceSelect.value = "";
        
        joinModal.classList.remove("hidden");
        document.body.classList.add("overflow-hidden");
        phoneInput.focus();
    }

    function closeJoinModalFn() {
        joinModal.classList.add("hidden");
        document.body.classList.remove("overflow-hidden");
    }

    // ========== Search & Filter Functions ==========
    function filterAndDisplayEvents() {
        const searchQuery = searchInput.value.trim().toLowerCase();
        const eventCards = Array.from(document.querySelectorAll(".eventCard"));
        
        let visibleCards = eventCards.filter(card => {
            const searchText = card.getAttribute("data-search").toLowerCase();
            return searchText.includes(searchQuery);
        });

        // Sort
        const sortValue = sortSelect.value;
        visibleCards.sort((a, b) => {
            if (sortValue === "date-asc") {
                return parseInt(a.getAttribute("data-date")) - parseInt(b.getAttribute("data-date"));
            } else if (sortValue === "date-desc") {
                return parseInt(b.getAttribute("data-date")) - parseInt(a.getAttribute("data-date"));
            } else if (sortValue === "title") {
                return a.getAttribute("data-title").localeCompare(b.getAttribute("data-title"));
            }
            return 0;
        });

        // Hide all, show visible
        eventCards.forEach(card => card.classList.add("hidden"));
        visibleCards.forEach(card => card.classList.remove("hidden"));

        // Update count and no-results message
        eventCountSpan.textContent = visibleCards.length;
        eventCountPluralSpan.textContent = visibleCards.length === 1 ? "" : "s";
        noResultsMessage.classList.toggle("hidden", visibleCards.length > 0);
    }

    // ========== Event Listeners ==========
    searchInput.addEventListener("input", filterAndDisplayEvents);
    sortSelect.addEventListener("change", filterAndDisplayEvents);

    openJoinButtons.forEach(button => {
        button.addEventListener("click", function () {
            openJoinModal(
                button.dataset.eventId,
                button.dataset.eventTitle,
                button.dataset.eventLocation
            );
        });
    });

    closeModalBtn.addEventListener("click", closeJoinModalFn);
    cancelModalBtn.addEventListener("click", closeJoinModalFn);
    joinModal.addEventListener("click", function (e) {
        if (e.target === joinModal) closeJoinModalFn();
    });

    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape" && !joinModal.classList.contains("hidden")) {
            closeJoinModalFn();
        }
    });

    // ========== Initialize ==========
    filterAndDisplayEvents();
</script>
</body>
</html>