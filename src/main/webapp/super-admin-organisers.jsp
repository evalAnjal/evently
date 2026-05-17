<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>SUPER_ADMIN | Organiser Approvals</title>
</head>
<body class="bg-slate-100 min-h-screen">
<div class="max-w-6xl mx-auto px-4 py-8">
    <header class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Organiser Approval Queue</h1>
            <p class="text-sm text-slate-600">Approve organisation registrations to grant ADMIN access.</p>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="text-indigo-600 text-sm">Logout</a>
    </header>

    <c:if test="${param.success == 'approved'}">
        <div class="mb-4 rounded-md border border-green-200 bg-green-50 text-green-800 px-4 py-3 text-sm">Organiser approved and promoted to ADMIN.</div>
    </c:if>
    <c:if test="${param.success == 'rejected'}">
        <div class="mb-4 rounded-md border border-amber-200 bg-amber-50 text-amber-800 px-4 py-3 text-sm">Organiser application rejected.</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="mb-4 rounded-md border border-red-200 bg-red-50 text-red-700 px-4 py-3 text-sm">Action failed. Please retry.</div>
    </c:if>

    <section class="bg-white rounded-lg border border-slate-200 overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-slate-50 border-b border-slate-200">
            <tr>
                <th class="text-left px-4 py-3">Organisation</th>
                <th class="text-left px-4 py-3">Email</th>
                <th class="text-left px-4 py-3">District</th>
                <th class="text-left px-4 py-3">Phone</th>
                <th class="text-left px-4 py-3">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="org" items="${pendingOrganisers}">
                <tr class="border-b border-slate-100">
                    <td class="px-4 py-3">
                        <div class="font-medium text-slate-900">${org.name}</div>
                        <div class="text-xs text-slate-500">${org.address}</div>
                    </td>
                    <td class="px-4 py-3">${org.email}</td>
                    <td class="px-4 py-3">${org.district}</td>
                    <td class="px-4 py-3">${org.phone}</td>
                    <td class="px-4 py-3">
                        <div class="flex gap-2">
                            <form method="post" action="${pageContext.request.contextPath}/super-admin/organisers">
                                <input type="hidden" name="organiserId" value="${org.id}">
                                <input type="hidden" name="action" value="approve">
                                <button class="px-3 py-1.5 rounded bg-indigo-600 text-white text-xs">Approve</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/super-admin/organisers">
                                <input type="hidden" name="organiserId" value="${org.id}">
                                <input type="hidden" name="action" value="reject">
                                <button class="px-3 py-1.5 rounded bg-slate-200 text-slate-800 text-xs">Reject</button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty pendingOrganisers}">
                <tr>
                    <td colspan="5" class="px-4 py-8 text-center text-slate-500">No pending organiser applications.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </section>
</div>
</body>
</html>
