<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TFathersProfile
 * 
 * @property int $FATHERS_ID
 * @property string $FATHER_MOTHER_TONGUE
 * @property string $FATHER_OTHER_DIALECTS
 * @property string $FATHER_EDUCATIONAL_ATTAINMENT
 * @property int $RESIDENT_ID
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TResidentBasicInfo $t_resident_basic_info
 *
 * @package App\Models
 */
class TFathersProfile extends Eloquent
{
	protected $table = 't_fathers_profile';
	protected $primaryKey = 'FATHERS_ID';
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
		'FATHER_MOTHER_TONGUE',
		'FATHER_OTHER_DIALECTS',
		'FATHER_EDUCATIONAL_ATTAINMENT',
		'RESIDENT_ID',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_resident_basic_info()
	{
		return $this->belongsTo(\App\Models\TResidentBasicInfo::class, 'RESIDENT_ID');
	}
}
