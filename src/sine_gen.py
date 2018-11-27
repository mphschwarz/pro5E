#!/bin/python
import math

bits = 12
samples = 100

sine = math.sin(linspace(0, math.pi / 2, samples) * math.pow(2, bits)

print(sine)

def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0:
        val = val - (1 << bits)
    return val
