.pragma library

var dimension = 5;
var numberOfMines = 4;
var mines = (function() { return initMinesweeper(); })();
var cascadeOpenCells = [];

function getNumberOfMines() {
    return mines.length
}

function setMines() {
    mines = initMinesweeper();
}

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function initMinesweeper() {
    var mines = [];
    //var count = randomInt(1, dimension * dimension / 2);
    var count = numberOfMines;
    while(mines.length < count) {
        var idx = randomInt(0, dimension * dimension - 1);
        if(mines.indexOf(idx) === -1) {
            mines.push(idx);
        }
    }

    return mines;
}

function isCellForCascadeOpen(position) {
    return cascadeOpenCells.indexOf(position) >= 0
}

function isExplosivePosition(position) {
    return mines.indexOf(position) >= 0;
}

function explosiveSiblingCount(position) {
    var count = 0;

    // check the previous cell if this cell is not the first cell in this row
    function leftNeighborhood(position) {
        if(position % dimension != 0) {
            return isExplosivePosition(position - 1) ? 1 : 0;
        }

        return 0;
    }

    // check the next cell if this cell is not the last cell in this row
    function rightNeighborhood(position) {
        if((position + 1) % dimension != 0) {
            return isExplosivePosition(position + 1) ? 1 : 0;
        }

        return 0;
    }

    count += leftNeighborhood(position);
    count += rightNeighborhood(position);

    // check cells above this one
    if(position >= dimension) {
        count += isExplosivePosition(position - dimension) ? 1 : 0;
        count += leftNeighborhood(position - dimension);
        count += rightNeighborhood(position - dimension);
    }

    // check cells below this one
    if(position + dimension < dimension * dimension) {
        count += isExplosivePosition(position + dimension) ? 1 : 0;
        count += leftNeighborhood(position + dimension);
        count += rightNeighborhood(position + dimension);
    }

    return count;
}

function getCellsToOpen(position) {
    if (isExplosivePosition(position) || explosiveSiblingCount(position) !== 0) {
      return [position];
    }

    var cellPositions = [position];
    function openCellsRecursively(idx) {
        if (idx > cellPositions.length - 1) {
            return
        }

         // this if blocks further openning of cells with numbers
        if (explosiveSiblingCount(cellPositions[idx]) === 0) {
            var x = cellPositions[idx] % dimension;
            var y = cellPositions[idx] / dimension >> 0; //integer division
            var shifts = [-1 , 0, 1];
            var len = shifts.length;
            for (var i = 0; i < len; i++) {
                var shiftedX = x + shifts[i];
                if (shiftedX < 0 || shiftedX > dimension - 1) continue;
                for (var j = 0; j < len; j++) {
                    var shiftedY = y + shifts[j];
                    if (shiftedY < 0 || shiftedY > dimension - 1) continue;

                    if (shifts[i] === 0 && shifts[j] === 0) continue;
                    var posToCheck = shiftedX + shiftedY * dimension;
                    if (!isExplosivePosition(posToCheck)) { //explosiveSiblingCount(posToCheck) === 0 &&

                        if (cellPositions.indexOf(posToCheck) === -1) {
                            cellPositions.push(posToCheck);
                        }

                    }
                }
            }
        }
        openCellsRecursively(idx + 1);
    }
    openCellsRecursively(0);
    return cellPositions;
}
