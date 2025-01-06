<?php 

global $memory;
$memory = 0;
function memprof(string $label = 'default')
{
    global $memory;
    $fixedMem = memory_get_usage();
    echo PHP_EOL."[{$label}] ".round($memory / 1024 / 1024, 2).'mb -> '.round($fixedMem / 1024 / 1024, 2) . 'mb '.PHP_EOL;
    $memory = $fixedMem;
}
