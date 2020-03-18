<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THsAdolescent
 * 
 * @property int $ADOLESCENT_ID
 * @property int $RESIDENT_ID
 * @property \Carbon\Carbon $MMRTD_DATE
 * @property int $IS_REFERRED
 * @property \Carbon\Carbon $DATE_OF_VISIT
 * @property string $REMARKS
 * @property int $CS_DIABETIC
 * @property int $CS_MATAAS_PRESYON
 * @property int $CS_CANCER
 * @property int $CS_BUKOL
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 *
 * @package App\Models
 */
class THsAdolescent extends Eloquent
{
	protected $table = 't_hs_adolescent';
	protected $primaryKey = 'ADOLESCENT_ID';
	public $timestamps = false;

	protected $casts = [
		'RESIDENT_ID' => 'int',
		'IS_REFERRED' => 'int',
		'CS_DIABETIC' => 'int',
		'CS_MATAAS_PRESYON' => 'int',
		'CS_CANCER' => 'int',
		'CS_BUKOL' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'MMRTD_DATE',
		'DATE_OF_VISIT',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'RESIDENT_ID',
		'MMRTD_DATE',
		'IS_REFERRED',
		'DATE_OF_VISIT',
		'REMARKS',
		'CS_DIABETIC',
		'CS_MATAAS_PRESYON',
		'CS_CANCER',
		'CS_BUKOL',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}
}
