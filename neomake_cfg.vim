" Neomake execution configuration.
autocmd BufWritePost,BufReadPost *.cc,*.h Neomake

" Project-specific neomake configuration.
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
\ 'exe' : 'clang',
\ 'args' : [
\ '-fsyntax-only',
\ '-xc++',
\ '-Wall',
\ '-Wextra',
\ '-Werror',
\ '-Wno-enum-compare',
\ '-Wno-ignored-qualifiers',
\ '-Wno-unused-parameter',
\ '-msse2',
\ '-mcx16',
\ '-mtune=sandybridge',
\ '-D_GNU_SOURCE',
\ '-D__STDC_FORMAT_MACROS',
\ '-DARENA_LSAN_LEVEL=1',
\ '-Wno-invalid-offsetof',
\ '-std=c++11',
\ '-gcc-toolchain',
\ '/opt/rh/devtoolset-3/root/usr',
\ '-B',
\ '/opt/rh/devtoolset-3/root/usr/bin',
\ '-Qunused-arguments',
\ '-Wno-deprecated-register',
\ '-Wno-unused-local-typedef',
\ '-isystem',
\ '/opt/rh/devtoolset-3/root/usr/include/c++/4.9.2',
\ '-isystem',
\ '/opt/rh/devtoolset-3/root/usr/include/c++/4.9.2/x86_64-redhat-linux',
\ '-isystem',
\ '/opt/rh/devtoolset-3/root/usr/include/c++/4.9.2/backward',
\ '-I',
\ '/home/apyatkov/projects/main',
\ '-I',
\ '/home/apyatkov/projects/main/build',
\ '-I',
\ '/home/apyatkov/projects/main/build/toolchain/include'
\ ]
\ }
