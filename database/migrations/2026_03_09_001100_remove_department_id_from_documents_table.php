<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration {

    public function up(): void
    {
        // Drop foreign key first
        Schema::table('documents', function (Blueprint $table) {
            if (Schema::hasColumn('documents', 'department_id')) {
                $table->dropForeign(['department_id']);
            }
        });

        // Drop all indexes related to department_id (SQLite specific)
        if (DB::getDriverName() === 'sqlite') {
            DB::statement('DROP INDEX IF EXISTS documents_department_id_index');
            DB::statement('DROP INDEX IF EXISTS documents_department_id_status_index');
            DB::statement('DROP INDEX IF EXISTS documents_department_perf_index');
        }

        // Finally drop the column
        Schema::table('documents', function (Blueprint $table) {
            if (Schema::hasColumn('documents', 'department_id')) {
                $table->dropColumn('department_id');
            }
        });
    }

    public function down(): void
    {
        if (Schema::hasColumn('documents', 'department_id')) {
            return;
        }

        Schema::table('documents', function (Blueprint $table) {
            $table->foreignId('department_id')
                ->nullable()
                ->constrained('departments')
                ->after('amount');

            $table->index('department_id');
            $table->index(['department_id', 'status']);
            $table->index('department_id', 'documents_department_perf_index');
        });
    }
};
