module.exports = [
	// expose a SolutionBase property like in mediapipe python
	["mediapipe.framework.solution_base.", "", ["/Properties"], [
		["mediapipe::autoit::solution_base::SolutionBase", "SolutionBase", "", ["/R", "=this"]],
	], "", ""],
];
