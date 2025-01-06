<?php

$_ENV = getenv();
$user = $_ENV['DB_CMS_USER'];
$pass = $_ENV['DB_CMS_PASS'];
$host = $_ENV['DB_CMS_HOST'];
print_r([$user, $pass, $host]);
$pdo = new PDO("mysql:host=$host;dbname=cms", $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
]);
$pdo->setAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY, false);

while ($query = readline('sql>')) {
    readline_add_history($query);
    try {
        if (strpos(strtolower($query), "insert") !== false || strpos(strtolower($query), "update") !== false || strpos(strtolower($query), "delete") !== false) {
            $count = $pdo->exec($query);
            print "$count affected rows." . PHP_EOL;
            continue;
        }
        $unbufferedResult = $pdo->query($query);
        foreach ($unbufferedResult as $row) {
            if (count($row) < 4) {
                echo json_encode($row) . PHP_EOL;
            } else {
                echo json_encode($row, JSON_PRETTY_PRINT) . PHP_EOL;
            }
        }
    } catch (Throwable $e) {
        print "ERROR: {$e->getMessage()}" . PHP_EOL;
    }
}
