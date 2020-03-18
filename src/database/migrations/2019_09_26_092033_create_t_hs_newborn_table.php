<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateTHsNewbornTable extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('t_hs_newborn', function(Blueprint $table)
		{
			$table->integer('NEWBORN_ID', true);
			$table->integer('RESIDENT_ID')->nullable()->index('FK_HS_NB_R_ID');
			$table->string('TYPE_OF_HOME_RECORD', 100)->nullable();
			$table->string('BIRTH_WEIGHT', 25)->nullable();
			$table->string('BIRTH_LENGTH', 25)->nullable();
			$table->integer('HAD_BCG')->nullable();
			$table->integer('HAD_HEPA_B')->nullable();
			$table->integer('HAD_NEWBORN_SCREENING')->nullable();
			$table->integer('HAD_BREASTFEED')->nullable();
			$table->string('DANGERS_OBSERVED', 25)->nullable();
			$table->boolean('DO_A')->nullable()->default(0);
			$table->boolean('DO_B')->nullable()->default(0);
			$table->boolean('DO_C')->nullable()->default(0);
			$table->boolean('DO_D')->nullable()->default(0);
			$table->boolean('DO_E')->nullable()->default(0);
			$table->boolean('DO_F')->nullable()->default(0);
			$table->string('SOURCE_OF_SERVICE_RESERVED', 100)->nullable();
			$table->dateTime('CREATED_AT')->nullable();
			$table->dateTime('UPDATED_AT')->nullable();
			$table->integer('ACTIVE_FLAG')->nullable();
			$table->integer('NONRESIDENT_ID')->nullable()->index('FK_NEWBORN_NONRESIDENT');
		});
	}


	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('t_hs_newborn');
	}

}
