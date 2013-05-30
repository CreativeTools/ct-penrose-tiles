------------------------- BSD License  -----------------------
-- Copyright (c) 2013, Creative Tools AB
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

--  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
-- TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------

rollout penroseRollout "Penrose tiler" (
	spinner sideLengthSpinner "Side Length" range:[0.0,500.0,37.123]
	spinner iterationSpinner "Iterations" type:#integer range:[1,20,3]
	checkbox removeOld "remove Old" checked:true
	button generateButton "Generate"
	button clearButton "Clear tiles"
		
	function getHalfKite mirror_ = (
		if mirror_ then
			return instance halfKiteM
		else
			return instance halfKite
	)

	function getHalfDart mirror_ = (
		if mirror_ then
			return instance halfDartM
		else
			return instance halfDart
	)

	function replaceKite oldPart sideLength newSideLength sf deleteOld mirror_= (
		halfKites = #()
		halfDarts = #()
		t = oldPart.transform
		p = t.translationpart
		q = t.rotationpart
		mirrorMult = 1
		if mirror_ then
			mirrorMult = -1
		identity t
		scale t [sf, sf, sf]
		rotateZ t (mirrorMult * 36)
		rotate t q
		translate t p
		newPart = getHalfDart (mirror_==false)
		newPart.transform = t
		newPart.name = "penroseHalfDartClone"
		append halfDarts #(newPart, mirror_==false)
			
		a = 36.0 * 0.5
		w = cos(a) * newSideLength
		h = sin(a) * newSideLength
		t = oldPart.transform
		identity t
		scale t [sf, sf, sf]
		rotateZ t (mirrorMult*(-108))
		translate t [mirrorMult*w,-sideLength+h,0]
		rotate t q
		translate t p
		newPart = getHalfKite (mirror_==true)
		newPart.transform = t
		newPart.name = "penroseHalfKiteClone"
		append halfKites #(newPart, mirror_==true)
		newPart = getHalfKite (mirror_==false)
		newPart.transform = t
		newPart.name = "penroseHalfKiteClone"
		append halfKites #(newPart, mirror_==false)
		
		if deleteOld == true then (
			delete oldPart
		)
		
		return #(halfKites, halfDarts)
	)

	function replaceDart oldPart sideLength newSideLength sf deleteOld mirror_= (
		halfKites = #()
		halfDarts = #()
		t = oldPart.transform
		p = t.translationpart
		q = t.rotationpart
		mirrorMult = 1
		if mirror_ then
			mirrorMult = -1
		identity t
		scale t [sf, sf, sf]
		rotate t q
		translate t p
		newPart = getHalfKite (mirror_==true)
		newPart.transform = t
		newPart.name = "penroseHalfKiteClone"
		append halfKites #(newPart, mirror_==true)
		
		a = 18
		w = cos(a) * newSideLength
		h = sin(a) * newSideLength
		identity t
		scale t [sf, sf, sf]
		rotateZ t (mirrorMult*(-144))
		translate t [mirrorMult*w,-sideLength+h,0]
		rotate t q
		translate t p
		newPart = getHalfDart (mirror_==true)
		newPart.transform = t
		newPart.name = "penroseHalfDartClone"
		append halfDarts #(newPart, mirror_==true)
		
		if deleteOld == true then (
			delete oldPart
		)
		
		return #(halfKites, halfDarts)
	)
	
	function clearOld = (
		delete $penroseHalfDartClone*
		delete $penroseHalfKiteClone*
	)

	function generate = (
		if removeOld.checked then (
			clearOld()
		)
		
		halfKite = $HalfKite
		halfKiteM = $HalfKiteM
		halfDart = $HalfDart
		halfDartM = $HalfDartM
		
		hk = #()
		hd = #()

		scaleFactor = 2/(1+sqrt(5))  -- Inverse golden ratio
		newSideLength = sideLengthSpinner.value
		
		for obj in selection do(
			if (getUserProp obj "templateDart") != undefined then(
				append hd #(obj,false)
				append hd #(obj,true)
			)
			if (getUserProp obj "templateKite") != undefined then(
				append hk #(obj,false)
				append hk #(obj,true)
			)
		)

		for i=1 to iterationSpinner.value do (
			newHk = #()
			newHd = #()
			
			sf = pow scaleFactor i

			sideLength = newSideLength
			newSideLength = sideLength * scaleFactor

			for val in hk do(
				newParts = replaceKite val[1] sideLength newSideLength sf (i!=1) val[2]
				join newHk newParts[1]
				join newHd newParts[2]
			)
			for val in hd do(
				newParts = replaceDart val[1] sideLength newSideLength sf (i!=1) val[2]
				join newHk newParts[1]
				join newHd newParts[2]
			)
			
			hk = newHk
			hd = newHd
		)
	)
	
	on clearButton pressed do (
		clearOld()
	)
	
	on generateButton pressed do (
		generate()
	)
)

createDialog penroseRollout