<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsNewborn
 * 
 * @property int $NEWBORN_ID
 * @property int $RESIDENT_ID
 * @property string $TYPE_OF_HOME_RECORD
 * @property string $BIRTH_WEIGHT
 * @property string $BIRTH_LENGTH
 * @property int $HAD_BCG
 * @property int $HAD_HEPA_B
 * @property int $HAD_NEWBORN_SCREENING
 * @property int $HAD_BREASTFEED
 * @property string $DANGERS_OBSERVED
 * @property int $DO_A
 * @property int $DO_B
 * @property int $DO_C
 * @property int $DO_D
 * @property int $DO_E
 * @property int $DO_F
 * @property string $SOURCE_OF_SERVICE_RESERVED
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 * @property \Illuminate\Database\Eloquent\Collection $t_hs_infants
 *
 * @package App\Models
 */
class THsNewborn extends Eloquent
{
	protected $table = 't_hs_newborn';
	protected $primaryKey = 'NEWBORN_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'HAD_BCG' => 'int',
		'HAD_HEPA_B' => 'int',
		'HAD_NEWBORN_SCREENING' => 'int',
		'HAD_BREASTFEED' => 'int',
		'DO_A' => 'int',
		'DO_B' => 'int',
		'DO_C' => 'int',
		'DO_D' => 'int',
		'DO_E' => 'int',
		'DO_F' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'TYPE_OF_HOME_RECORD',
		'BIRTH_WEIGHT',
		'BIRTH_LENGTH',
		'HAD_BCG',
		'HAD_HEPA_B',
		'HAD_NEWBORN_SCREENING',
		'HAD_BREASTFEED',
		'DANGERS_OBSERVED',
		'DO_A',
		'DO_B',
		'DO_C',
		'DO_D',
		'DO_E',
		'DO_F',
		'SOURCE_OF_SERVICE_RESERVED',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}

	public function t_hs_infants()
	{
		return $this->hasMany(\App\Models\THsInfant::class, 'NEW_BORN_ID');
	}
}
