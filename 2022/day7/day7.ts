import * as fs from 'fs'

interface File {
    name: string;
    size: number;
}

interface Directory {
    name: string;
    parent: Directory | null;
    subdirectories: Array<Directory>;
    files: Array<File>;
}

const t0 = new Date()

const input = fs.readFileSync('day7.txt', 'utf8')
const lines = input.split('\n')

const root = {name: '/', parent: null, subdirectories: new Array<Directory>(), files: new Array<File>()}
let currentDir: Directory = root

lines.forEach(line => {
    if (line.startsWith('$ cd')) {
        const nextDir = line.split(' ')[2]
        if (nextDir === '/') currentDir = root;
        else if (nextDir === '..') {
            currentDir = currentDir.parent ?? root
        } else {
            currentDir = currentDir.subdirectories.find(dir => dir.name == nextDir)
                         ?? {name: nextDir, parent: currentDir, subdirectories: [], files: []}
        }
    } else if (line.startsWith('$ ls')) {
        // nothing to do here, we get output in the next line
    } else if (line.startsWith("dir")) {
        currentDir.subdirectories
            .push({name: line.split(' ')[1], parent: currentDir, subdirectories: [], files: []})
    } else {
        const [size, name] = line.split(' ')
        currentDir.files.push({name: name, size: Number(size)})
    }
})

const printDirectory = (root: Directory, level: number = 0) => {
    console.log('\t'.repeat(level) + ' Dir: %s', root.name)
    root.files.forEach(f => console.log('\t'.repeat(level) + ' File: %s %d', f.name, f.size))
    root.subdirectories.forEach(d => printDirectory(d, level + 1))
}

const getDirectorySize = (dir: Directory): number =>
    dir.files.map(f => f.size).reduce((a, b) => a + b, 0) +
    dir.subdirectories.map(getDirectorySize).reduce((a, b) => a + b, 0)

const getSubdirectories = (dir: Directory): Array<Directory> =>
    Array.from(
        new Set([dir].concat(
            dir.subdirectories.concat(dir.subdirectories.flatMap(getSubdirectories))))
        .values())

const dirs = getSubdirectories(root)
const dirSizes = dirs
    .map(d => getDirectorySize(d))

const part1 = dirSizes
    .filter(s => s <= 100000)
    .reduce((a, b) => a + b, 0)

console.log('Part 1: %d', part1)

const needed = 30000000 - (70000000 - getDirectorySize(root))

const part2 = Math.min(...dirSizes.filter(s => s >= needed))

console.log('Part 2: %d', part2)

const t1 = new Date()
const time = +t1 - +t0
console.log('Execution took: %dms', time)