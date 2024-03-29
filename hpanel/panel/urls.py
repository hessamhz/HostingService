from django.contrib import admin
from django.urls import path, include
from .views import login_form, login_view, admin_panel, user_view, user_update, user_update_form, logout_form, user_create, user_create_form
from .views import login_as_user_form, user_panel, change_password, change_password_form, delete_user_form


urlpatterns = [
    path('', login_view, name='login'),
    path('login-form', login_form, name='login-form'),
    path('admin-panel/', admin_panel, name='admin-panel'),
    path('user-panel/', user_panel, name='user-panel'),
    path('user-panel/change-password/', change_password, name='change-password'),
    path('user-panel/change-password/form', change_password_form, name='change-password-form'),
    path('admin-panel/profile', user_view, name='profile_list'),
    path('admin-panel/profile/<int:pk>/', user_update, name='user-update'),
    path('admin-panel/profile/update/<int:pk>/', user_update_form, name='user-update-form'),
    path('admin-panel/profile/login/<int:pk>/', login_as_user_form, name='login-user-form'),
    path('admin-panel/profile/delete/<int:pk>/', delete_user_form, name='delete-user-form'),
    path('logout', logout_form, name='logout'),
    path('admin-panel/create/', user_create, name='user-create'),
    path('admin-panel/create/form/', user_create_form, name='user-create-form'),
]
