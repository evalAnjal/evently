<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>SUPER_ADMIN | Dashboard</title>
</head>
<body class="bg-slate-100 min-h-screen">
<div class="max-w-6xl mx-auto px-4 py-8">
    <header class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Super Admin Dashboard</h1>
            <p class="text-sm text-slate-600">Overview of platform activity and quick actions.</p>
        </div>
        <div class="flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/super-admin/organisers" class="text-slate-700 text-sm">Organisers</a>
            <a href="${pageContext.request.contextPath}/logout" class="text-indigo-600 text-sm">Logout</a>
        </div>
    </header>

    <section class="grid grid-cols-1 sm:grid-cols-4 gap-4 mb-6">
        <div class="bg-white rounded-lg p-4 shadow-sm border">
            <div class="text-sm text-slate-500">Total Users</div>
            <div class="text-2xl font-semibold text-slate-900">${totalUsers}</div>
        </div>
        <div class="bg-white rounded-lg p-4 shadow-sm border">
            <div class="text-sm text-slate-500">Total Events</div>
            <div class="text-2xl font-semibold text-slate-900">${totalEvents}</div>
        </div>
        <div class="bg-white rounded-lg p-4 shadow-sm border">
            <div class="text-sm text-slate-500">Verified Organisers</div>
            <div class="text-2xl font-semibold text-slate-900">${verifiedOrganisersCount}</div>
        </div>
        <div class="bg-white rounded-lg p-4 shadow-sm border">
            <div class="text-sm text-slate-500">Pending Organisers</div>
            <div class="text-2xl font-semibold text-slate-900">${pendingOrganisersCount}</div>
        </div>
    </section>

    <section class="bg-white rounded-lg border border-slate-200 overflow-hidden">
        <div class="px-4 py-4 border-b border-slate-100">
            <h2 class="text-lg font-semibold text-slate-900">Recent Events</h2>
            <p class="text-sm text-slate-600">Latest events created on the platform.</p>
        </div>
        <table class="w-full text-sm">
            <thead class="bg-slate-50 border-b border-slate-200">
            <tr>
                <th class="text-left px-4 py-3">Title</th>
                <th class="text-left px-4 py-3">Date</th>
                <th class="text-left px-4 py-3">District</th>
                <th class="text-left px-4 py-3">Status</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="e" items="${recentEvents}">
                <tr class="border-b border-slate-100">
                    <td class="px-4 py-3">${e.title}</td>
                    <td class="px-4 py-3">
                        <c:choose>
                            <c:when test="${not empty e.eventDate}">${e.eventDate}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </td>
                    <td class="px-4 py-3">${e.district}</td>
                    <td class="px-4 py-3">${e.status}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty recentEvents}">
                <tr>
                    <td colspan="4" class="px-4 py-8 text-center text-slate-500">No events found.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </section>
    
</div>
</body>
</html>
