<?php

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    $data = [
        'user_id'       => '012',
        'username'      => 'noah_hall',
        'email'         => 'noah@example.com',
        'last_activity' => '2023-01-10 19:45:00',
    ];
    Cache::forever('foo', $data); // ✅ persists in Redis

// store "forever" (no TTL)
//    Cache::put('foo', $data,  now()->addMinutes(30));
    return view('welcome');
});
