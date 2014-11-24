# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

	.cpu cortex-m4
	.syntax unified
	.thumb

.section .text
	.org 0
	
	.word 0x20002000	/* stack top address */
	.word _start		/* 1 Reset */
	.word hang		/* 2 NMI */
	.word hang		/* 3 HardFault */
	.word hang		/* 4 MemManage */
	
#.thumb_func
.global _start
_start:
	# Enable the GPIOD clock
	ldr	r3, =0x40023830
	ldr	r2, [r3]
	orr	r2, #8
	str	r2, [r3]
	
	# Configure pin D6 for output
	ldr	r3, =0x40020C00
	ldr	r2, [r3]
	orr	r2, r2, #0x1000000
	str	r2, [r3]
	
	# Load the address and content for the GPIO output register
	ldr     r3, =0x40020C14
	ldr	r2, [r3]
	
_loop:
	# Toggle the LED on pin D6
	eor	r2, #4096
	str	r2, [r3]
	
	# Delay loop
	mov	r4, #0xFF000
_delay:
	nop
	subs	r4, #1
	bne	_delay
	
	# Repeat forever
	b	_loop

#.thumb_func
hang:   b hang

.end
