#!/usr/bin/env python3

import os
import subprocess
import random

def random_phrase():
    phrases = [
        'MAX TURBO',
        'ULTRA NITRO',
        'MEGA BLASTER',
        'HYPER BIONIC',
        'EXTREME HYPERPROCESSOR',
        'ULTIMATE COSMIC',
        'SUPER TRANSLUSCENT',
        'FINAL ROBOTIC',
        'INTERGALATIC POWERLIGHT',
        'NANO POWER CONVERTER',
        'SUBSPACE MOLECULE GENERATOR',
        'INTERDIMENSIONAL HYPERX',
        'POWER GENETIC TRANSPORTER'
    ]
    return random.choice(phrases)

def random_build_phrase():
    prefixes = [
        'MAX', 'TURBO', 'ULTRA', 'NITRO', 'MEGA', 'BLASTER', 'HYPER', 'BIONIC',
        'SPACE', 'EXTREME', 'ULTIMATE', 'COSMIC', 'SUPER', 'TRANSLUSCENT',
        'FINAL', 'ROBOTIC', 'INTERGALATIC', 'NANO', 'POWER', 'SUBSPACE',
        'INTERDIMENSIONAL',
    ]
    suffixes =[
        'HYPERPROCESSOR', 'POWERLIGHT', 'POWER CONVERTER', 'MOLECULE GENERATOR',
        'HYPERX', 'GENETIC TRANSPORTER', 'ACCELERATOR', 'QUADRATIC ENGINES'
    ]
    return random.choice(prefixes) + ' ' + random.choice(suffixes)

def random_verb():
    verbs = [
        'ACTIVATED', 'STARTED', 'NEUTRALIZED', 'DESTROYED', 'INTERRUPTED',
        'ACCELERATED', 'HEATING UP', 'SHUTTING DOWN', 'DOWN', 'IGNITED',
        'TURNED ON', 'BOOTED SUCCESFULLY', 'RECOVERED', 'SENT TO INTERDIMENSIONAL RIFT',
        'TOOK OFF', 'LANDED'
    ]
    return random.choice(verbs)

def send_notification():
    subprocess.run(["dunstctl", "close-all"], check=True)
    if (random.randrange(1)):
        phrase = random_phrase()
    else:
        phrase = random_build_phrase()

    phrase = phrase + ' ' + random_verb()

    subprocess.run(["notify-send", phrase], check=True)

def clicked():
    '''Returns True if the button was clicked'''
    button = os.environ.get("BLOCK_BUTTON", None)
    return button

if clicked():
    send_notification()

print("TURBO")
