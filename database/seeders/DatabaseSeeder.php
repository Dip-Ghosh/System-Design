<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $batchSize = 100; // insert 10k at a time
        $total = 10000000;

        for ($i = 0; $i < $total / $batchSize; $i++) {
            User::factory($batchSize)->create();
        }
    }
}
