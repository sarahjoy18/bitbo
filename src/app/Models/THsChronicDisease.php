<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsChronicDisease
 * 
 * @property int $CHRONIC_DISEASE_ID
 * @property int $RESIDENT_ID
 * @property string $CHRONIC_DISEASE_NAME
 * @property int $HAD_HIGH_FEVER
 * @property \Carbon\Carbon $DATE_OF_VISIT
 * @property string $REMARKS
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 *
 * @package App\Models
 */
class THsChronicDisease extends Eloquent
{
	protected $table = 't_hs_chronic_disease';
	protected $primaryKey = 'CHRONIC_DISEASE_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'HAD_HIGH_FEVER' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'DATE_OF_VISIT',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'CHRONIC_DISEASE_NAME',
		'HAD_HIGH_FEVER',
		'DATE_OF_VISIT',
		'REMARKS',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}
}
