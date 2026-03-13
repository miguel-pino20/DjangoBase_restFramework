from django.shortcuts import render
from django.http import HttpResponsePermanentRedirect

# Create your views here.
def default404(request):    
    return render(request, "404.html", {},status=404)


def not_found_view(request, exception=None):
    if not request.path.endswith('/'):
        return HttpResponsePermanentRedirect(request.path + '/')
    return default404(request)