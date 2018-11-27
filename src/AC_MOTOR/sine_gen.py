#!/bin/python
import numpy as np

bits = 12
samples = np.power(2, 6)
variable_name = 'sine'

def twos_comp(value, bits):
    if value < 0:
        value = ( 1<<bits ) + value
    formatstring = '{:0%ib}' % bits
    return formatstring.format(value)

sine = np.sin(np.linspace(0, 2 * np.pi, samples)) * np.power(2, bits - 1)
index = np.linspace(0, samples-1, samples)
bin_sine = []
for i in range(0, int(samples / 2)):
    bin_sine.append('\t\t\t{}[{}] = {}\'b{}; {}[{}] = {}\'b{};\n'.format(variable_name, i * 2, bits, twos_comp(int(sine[i * 2]), bits),
                                                                     variable_name, i * 2 + 1, bits, twos_comp(int(sine[i * 2 + 1]), bits)))
# bin_sine = ['\t\t{}[{}] = {}\'b{}; {}[{}] = {}\'b{};'.format(variable_name, index[::2] bits, twos_comp(int(val), bits),
#                                                              variable_name, index[1::2] bits, twos_comp(int(val), bits),) for val in sine]]

# bin_sine.append('{}\'b{}'.format(bits, twos_comp(int(sine[-1]), bits)))
# names = ['{}[{}], '.format(variable_name, index) for index in range(0, samples - 2)]
# names.append('{}[{}]'.format(variable_name, samples -1))

# out_string = 'assign {{{}}} = {{{}}};'.format(''.join(names), ''.join(bin_sine))
print(''.join(bin_sine))
