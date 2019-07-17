from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login, authenticate
from .models import Profile, User
from django.contrib.auth.decorators import login_required
from django.views.generic import ListView, DetailView
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.contrib.auth.mixins import LoginRequiredMixin
# Create your views here.


def login_view(request):
    form = AuthenticationForm()
    return render(request, 'index.html', {'form': form})


def login_form(request):
    form = AuthenticationForm(data=request.POST)
    if form.is_valid():       # username = form.cleaned_data.get('username')
        username = form.cleaned_data.get('username')
        password = form.cleaned_data.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
        else:
            return HttpResponse("user doesn't exist")
        return redirect('admin-panel')
    else:
        return render(request, 'admin-panel.html')


@login_required(login_url='login')
def admin_panel(request):
    q2 = Profile.objects.filter(is_admin=True)
    use = request.user
    for q in q2:
        if use == q.user:
            return render(request, 'admin-panel.html')

    return HttpResponse('not admin')
    #return render(request, 'admin-panel.html', {'q2': q2})

@login_required(login_url='login')
def user_view(request):
    q2 = Profile.objects.filter(is_admin=True)
    use = request.user
    q1 = User.objects.all()
    for q in q2:
        if use == q.user:
            return render(request, 'profile_list.html', {'q1': q1})
    return HttpResponse('You are Not admin')
