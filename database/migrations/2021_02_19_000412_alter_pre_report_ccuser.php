<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AlterPreReportCcuser extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('report_ccuser', function (Blueprint $table) {
            $table->bigInteger('indate')->after('cc')->nullable()->default(0)->comment('发送时间');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('report_ccuser', function (Blueprint $table) {
            $table->dropColumn('indate');
        });
    }
}
