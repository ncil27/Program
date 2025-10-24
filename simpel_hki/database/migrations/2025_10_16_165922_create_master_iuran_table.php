<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::disableForeignKeyConstraints();

        Schema::create('master_iuran', function (Blueprint $table) {
            $table->integer('id')->primary()->autoIncrement();
            $table->year('tahun')->unique();
            $table->decimal('jumlah_patokan_tahunan', 15, 2);
            $table->text('keterangan')->nullable();
            $table->integer('updated_by')->nullable();
            $table->foreignId('created_by')->nullable()->constrained('users');
            $table->timestamps();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('master_iuran');
    }
};
