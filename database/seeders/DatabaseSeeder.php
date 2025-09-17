<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Faker\Factory as Faker;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        ini_set('memory_limit', '512M');   // or 1G

//        $batchSize = 100; // insert 10k at a time
//        $total = 10000000;
//
//        for ($i = 0; $i < $total / $batchSize; $i++) {
//            User::factory($batchSize)->create();
//        }

        $faker = Faker::create();
        $batchSize = 5000;      // bigger batches = fewer queries
        $totalUsers = 10000000;  // 1 million, adjust as needed

        // Pre-hash password once
        $password = Hash::make('password123');

        for ($batch = 0; $batch < $totalUsers / $batchSize; $batch++) {
            $users = [];

            for ($i = 0; $i < $batchSize; $i++) {
                $users[] = [
                    'name'              => $faker->name(),
                    // Generate fast unique email using counter + batch
                    'email'             => "user{$batch}_{$i}@" . $faker->freeEmailDomain(),
                    'email_verified_at' => $faker->boolean(70) ? $faker->dateTimeBetween('2023-01-01', '2025-12-31')->format('Y-m-d H:i:s') : null,
                    'password'          => $password,
                    'remember_token'    => $faker->boolean(30) ? Str::random(60) : null,
                    // Ensure created_at spans partition years
                    'created_at'        => $faker->dateTimeBetween('2023-01-01', '2025-12-31')->format('Y-m-d H:i:s'),
                    'updated_at'        => $faker->boolean(80) ? $faker->dateTimeBetween('-6 months', 'now')->format('Y-m-d H:i:s') : null,
                ];
            }

            // Bulk insert
            DB::table('users')->insert($users);

            // Memory cleanup
            unset($users);

            echo "✅ Seeded " . (($batch + 1) * $batchSize) . " users...\n";
        }
    }

    private function createTestUsers(): void
    {
        $testUsers = [
            [
                'name' => 'Admin User',
                'email' => 'admin@example.com',
                'email_verified_at' => now(),
                'password' => Hash::make('admin123'),
                'remember_token' => null,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Test User',
                'email' => 'test@example.com',
                'email_verified_at' => now(),
                'password' => Hash::make('test123'),
                'remember_token' => null,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'John Doe',
                'email' => 'john@example.com',
                'email_verified_at' => null, // Unverified user
                'password' => Hash::make('john123'),
                'remember_token' => null,
                'created_at' => now()->subDays(30),
                'updated_at' => now()->subDays(15),
            ],
        ];

        foreach ($testUsers as $user) {
            try {
                DB::table('users')->insert($user);
            } catch (\Exception $e) {
                echo "Test user {$user['email']} already exists or error occurred.\n";
            }
        }
    }

    /**
     * Show how users are distributed across partitions
     */
    private function showPartitionDistribution(): void
    {
        echo "\n=== Partition Distribution ===\n";

        $partitions = DB::select("
            SELECT
                PARTITION_NAME,
                TABLE_ROWS,
                ROUND(DATA_LENGTH/1024/1024, 2) as SIZE_MB
            FROM INFORMATION_SCHEMA.PARTITIONS
            WHERE TABLE_NAME = 'users'
            AND TABLE_SCHEMA = DATABASE()
            AND PARTITION_NAME IS NOT NULL
            ORDER BY PARTITION_NAME
        ");

        foreach ($partitions as $partition) {
            echo "Partition {$partition->PARTITION_NAME}: {$partition->TABLE_ROWS} rows, {$partition->SIZE_MB} MB\n";
        }

        echo "\n";
    }
}
