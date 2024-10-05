from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from firebase_admin import messaging
import json

@csrf_exempt
def send_notification(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)  # Load JSON body
            fcm_token = data.get('fcm_token')
            title = data.get('title')
            body = data.get('body')

            # Construct the message
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body,
                ),
                token=fcm_token,
            )

            # Send the message
            response = messaging.send(message)

            return JsonResponse({'success': True, 'response': response}, status=200)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)

    return JsonResponse({'error': 'Invalid request'}, status=400)

