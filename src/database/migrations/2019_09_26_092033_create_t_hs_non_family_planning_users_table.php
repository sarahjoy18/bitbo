<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;

class CreateTHsNonFamilyPlanningUsersTable extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('t_hs_non_family_planning_users', function(Blueprint $table)
		{
			$table->integer('NON_FP_ID', true);
			$table->integer('RESIDENT_ID')->nullable()->index('FK_HS_NON_FPU_R_ID');
			$table->integer('IS_INTERESTED_IN_FP')->nullable();
			$table->string('REASONS_NOT_USING', 100)->nullable();
			$table->date('DATE_OF_VISIT')->nullable();
			$table->dateTime('CREATED_AT')->nullable();
			$table->dateTime('UPDATED_AT')->nullable();
			$table->integer('ACTIVE_FLAG')->nullable();
		});
	}


	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('t_hs_non_family_planning_users');
	}

}
