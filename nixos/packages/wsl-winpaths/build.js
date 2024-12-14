import { $ } from "bun"
import { parseArgs } from "util"

const pathWithTrailingSlash = (dir) => (
  (dir !== '/' && !dir.endsWith('/'))
  ? dir.concat('/')
  : dir
)

const { values, _ } = parseArgs({
  strict: true,
  allowPositionals: true,
  args: Bun.argv,
  options: {
    defaultWslMountDir: {
      type: 'string',
    },
    // mountCommand: {
    //   type: 'string',
    // },
  },
})

const winMount = JSON.parse(
  await $`
    findmnt \
      -t 9p \
      -d backward \
      -fJo \
      source,target,options
  `.text()).filesystems.at(0)

/** windows command aliases **/
const wslpath = async args => (( await $`/bin/wslpath '${args}'`.text() ).split('\n').at(0))
const pshell = async command => await $`./powershell.exe ${command}`
  .cwd( await wslpath(winMount.source.concat('\Windows\\System32\\WindowsPowerShell\\v1.0')) )
  .text()

// need to remove trailing slash if default dir has one
const defaultMountDir = pathWithTrailingSlash(values.defaultWslMountDir)

// need to remove trailing slash if current dir has one
// @todo: need to compose an alternative using only pshell 'echo $env:windir'
const currentMountDir = pathWithTrailingSlash(
  winMount.options
    .split(/(;|,)/)
    .find(v => /^symlinkroot=/.test(v))
    .split(/^symlinkroot=/)
    .at(1)
)

const winPaths = await Promise.all(
  (await pshell('echo $env:path'))
    .split(';')
    .map((async path => 
      (await wslpath(path))
        .trim('\r')
        .replace(currentMountDir, defaultMountDir)
    ))
)

// console.log(JSON.stringify(winPaths))
await Bun.write(Bun.stdout, JSON.stringify(winPaths));