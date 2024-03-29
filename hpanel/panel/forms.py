from django.forms import ModelForm
from .models import User, Profile
from django.contrib.auth.forms import UserCreationForm, UserChangeForm


class UserForm(UserChangeForm):
    class Meta:
        model = User
        fields = ('username', 'password', 'email')


class ProfileForm(ModelForm):
    class Meta:
        model = Profile
        fields = ('domain_name', 'capacity')


class UserCreateForm(ModelForm):
    class Meta:
        model = User
        fields = ('username', 'password', 'email')


class ProfileCreateForm(ModelForm):
    class Meta:
        model = Profile
        fields = ('domain_name', 'is_admin', 'capacity')


class PasswordChange(UserChangeForm):
    class Meta:
        model = User
        fields = ('password',)