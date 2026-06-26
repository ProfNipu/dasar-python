from django.contrib.auth.backends import ModelBackend
from django.contrib.auth import get_user_model
from django.db.models import Q

User = get_user_model()


class FlexibleAuthBackend(ModelBackend):
    """
    Custom authentication backend yang support login dengan:
    1. Username (custom username)
    2. NIP (dari id_pegawai / B_02B)
    3. Email
    
    User bisa login dengan salah satu dari ketiganya
    """
    
    def authenticate(self, request, username=None, password=None, **kwargs):
        if username is None or password is None:
            return None
        
        try:
            # Cari user berdasarkan username, email, atau NIP
            # Query: username field ATAU email field bisa match dengan input
            user = User.objects.get(
                Q(username__iexact=username) |  # Match username (case insensitive)
                Q(email__iexact=username)       # Match email (case insensitive)
            )
            
            # Validasi password
            # Django akan otomatis detect Laravel bcrypt format dan verify
            if user.check_password(password):
                # Jika password valid dan masih format Laravel ($2y$),
                # Django akan otomatis re-hash ke format Django di next request
                return user
                
        except User.DoesNotExist:
            # User tidak ditemukan
            return None
        except User.MultipleObjectsReturned:
            # Multiple users found (shouldn't happen with proper constraints)
            return None
        
        return None
    
    def get_user(self, user_id):
        """Get user by ID"""
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None
