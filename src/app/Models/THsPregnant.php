<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsPregnant
 * 
 * @property int $PREGNANT_ID
 * @property int $RESIDENT_ID
 * @property string $TYPE_OF_HOME_RECORD
 * @property int $NUMBER_OF_MONTHS_PREGNANT
 * @property int $HAD_BIRTH_PLAN
 * @property int $BLOOD_TYPE
 * @property string $DANGERS_OBSERVED
 * @property \Carbon\Carbon $DUE_DATE
 * @property string $PREGNANCY_CONCLUSION
 * @property int $HAD_FERRO_SULFATE_FOLIC_ACID
 * @property int $HAD_TETANOUS_TOXOID_1
 * @property int $HAD_TETANOUS_TOXOID_2
 * @property int $HAD_TETANOUS_TOXOID_3
 * @property int $HAD_TETANOUS_TOXOID_4
 * @property int $HAD_TETANOUS_TOXOID_5
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_post_parta
 *
 * @package App\Models
 */
class THsPregnant extends Eloquent
{
	protected $table = 't_hs_pregnant';
	protected $primaryKey = 'PREGNANT_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'NUMBER_OF_MONTHS_PREGNANT' => 'int',
		'HAD_BIRTH_PLAN' => 'int',
		'BLOOD_TYPE' => 'int',
		'HAD_FERRO_SULFATE_FOLIC_ACID' => 'int',
		'HAD_TETANOUS_TOXOID_1' => 'int',
		'HAD_TETANOUS_TOXOID_2' => 'int',
		'HAD_TETANOUS_TOXOID_3' => 'int',
		'HAD_TETANOUS_TOXOID_4' => 'int',
		'HAD_TETANOUS_TOXOID_5' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'DUE_DATE',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'TYPE_OF_HOME_RECORD',
		'NUMBER_OF_MONTHS_PREGNANT',
		'HAD_BIRTH_PLAN',
		'BLOOD_TYPE',
		'DANGERS_OBSERVED',
		'DUE_DATE',
		'PREGNANCY_CONCLUSION',
		'HAD_FERRO_SULFATE_FOLIC_ACID',
		'HAD_TETANOUS_TOXOID_1',
		'HAD_TETANOUS_TOXOID_2',
		'HAD_TETANOUS_TOXOID_3',
		'HAD_TETANOUS_TOXOID_4',
		'HAD_TETANOUS_TOXOID_5',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}

	public function t_hs_post_parta()
	{
		return $this->hasMany(\App\Models\THsPostPartum::class, 'PREGNANT_ID');
	}
}
