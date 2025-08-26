<?php

use Elastic\Elasticsearch\ClientBuilder;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;
use Faker\Factory as Faker;

Route::get('/', function () {
    ini_set('max_execution_time', 0); // 0 = unlimited
    set_time_limit(0);

//    $client = ClientBuilder::create()
//        ->setHosts([env('ELASTICSEARCH_HOST')])
//        ->build();

    $faker     = Faker::create();
    $batchSize = 1000;
    $total     = 1000000; // 1M records

    for ($i = 1; $i <= $total; $i += $batchSize) {
        $params = ['body' => []];

        for ($j = 0; $j < $batchSize; $j++) {
            $id               = $i + $j;
            $params['body'][] = [
                'index' => [
                    '_index' => 'products',
                    '_id'    => $id,
                ],
            ];
            $params['body'][$id] = [
                'name'     => $faker->words(3, true),
                'price'    => $faker->randomFloat(2, 100, 3000),
                'in_stock' => $faker->boolean,
            ];


        }

        Cache::forever('products', $params);

//        $client->bulk($params);
//        $response = $client->index($params);

    }
        return view('welcome');
    });
