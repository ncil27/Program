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

        Schema::create('tbl_master_iuran', function (Blueprint $table) {
            $table->integer('id')->primary()->autoIncrement();
            $table->year('tahun')->unique();
            $table->decimal('nominal_tahunan', 15, 2);
            $table->text('keterangan')->nullable();
            $table->integer('updated_by')->nullable();
            $table->foreign('updated_by')->references('id_user')->on('tbl_users');
            $table->timestamp('updated_at')->nullable()->useCurrent();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tbl_master_iuran');
    }
};
