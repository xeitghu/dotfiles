#!/bin/bash

# Находим ID источника звука (микрофона), который использует Discord
DISCORD_SOURCE_ID=$(pactl list source-outputs | grep -B 20 "application.name = \"WEBRTC VoiceEngine\"" | grep "Source Output #" | awk '{print $3}' | sed 's/#//')

# Если Discord сейчас находится в голосовом чате (и ID найден)
if [ -n "$DISCORD_SOURCE_ID" ]; then
    # Переключаем состояние "мьюта" для этого конкретного источника
    pactl set-source-output-mute $DISCORD_SOURCE_ID toggle
fi
