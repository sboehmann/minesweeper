.pragma library

var dimension = 8;
var numberOfMines = 0;
var minePositons = [];
var tilesMarkedAsBombs = 0;

function setDimension(dim) {
    console.log("Setting dimension to " + dim)
    dimension = dim;
}

function resetMines() {
    numberOfMines = randomInt(dimension * dimension / 8, dimension * dimension / 4);
    minePositons = []
    tilesMarkedAsBombs = 0
}

function mines(excludedPosition) {
    if (minePositons.length === 0)
    {
        console.log("Setting mines")
        initMines(excludedPosition);
    }
    return minePositons;
}

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function initMines(excludedPosition) {
    var availablePositions = []
    for (var i = 0; i < dimension * dimension; i++) {
        if (i !== excludedPosition) {
            availablePositions.push(i);
        }
    }

    for (var i = 0; i < numberOfMines; i++) {
        var index = randomInt(0, availablePositions.length-1)
        minePositons.push(availablePositions[index]);
        availablePositions.splice(index, 1)
    }
}

function neighborhood(position) {
    var neighbors = [];
    var row = Math.floor(position / dimension)
    var col = position % dimension

    for (var r = row-1; r <= row+1; r++) {
        for (var c = col-1; c <= col+1; c++) {
            if (r>=0 && r<dimension && c>=0 && c<dimension) {
                var positionToCheck = r * dimension + c;
                if (positionToCheck != position) {
                    neighbors.push(positionToCheck);
                }
            }
        }
    }

    return neighbors;
}

function arrayContainsValue(array, value) {
    for (var i = 0; i < array.length; ++i) {
        if (array[i] === value) {
            return true;
        }
    }
    return false;
}

function addUniqueArray(array, arrayToAdd) {
    for (var i = 0; i < arrayToAdd.length; ++i) {
        if (!arrayContainsValue(array, arrayToAdd[i])) {
            array.push(arrayToAdd[i]);
        }
    }
}

function safeNeighborhood(position) {
    var neighbors = neighborhood(position);

    for (var i = 0; i < neighbors.length; ++i) {
        if (explosiveSiblingCount(neighbors[i]) === 0)
        {
            var newNeighbors = neighborhood(neighbors[i]);
            addUniqueArray(neighbors, newNeighbors);
        }
    }

    return neighbors;
}


function isExplosivePosition(position) {
    return mines(position).indexOf(position) >= 0;
}

function explosiveSiblingCount(position) {
    var count = 0;

    var neighbors = neighborhood(position)
    for (var i=0; i<neighbors.length; i++) {
        count += isExplosivePosition(neighbors[i])
    }

    return count;
}


function addBombMark() {
    tilesMarkedAsBombs++;
}

function removeBombMark() {
    tilesMarkedAsBombs--;
}

function bombsLeft() {
    return numberOfMines - tilesMarkedAsBombs;
}
