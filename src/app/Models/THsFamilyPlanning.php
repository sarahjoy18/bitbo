<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsFamilyPlanning
 * 
 * @property int $FD_ID
 * @property int $RESIDENT_ID
 * @property string $FP_METHOD
 * @property string $FP_SOURCE
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_family_planning_users_visitations
 *
 * @package App\Models
 */
class THsFamilyPlanning extends Eloquent
{
	protected $table = 't_hs_family_planning';
	protected $primaryKey = 'FD_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'FP_METHOD',
		'FP_SOURCE',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}

	public function t_hs_family_planning_users_visitations()
	{
		return $this->hasMany(\App\Models\THsFamilyPlanningUsersVisitation::class, 'FP_ID');
	}
}
