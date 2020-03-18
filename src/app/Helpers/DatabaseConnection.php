<?php
namespace App\Helpers;
use Config;
use DB;

class DatabaseConnection
{
    public static function setConnection($host,$port,$server_username,$server_password)
    {
        config(['database.connections.mysql' => [
            'driver' => 'mysql',
            'host' => $host,
            'port' => $port,
            'database' => 'test',
            'username' => $server_username,
            'password' => $server_password
        ]]);

        return DB::connection('mysql');
    }
}
?>