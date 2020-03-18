<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfTransientRecord
 * 
 * @property int $TRANSIENT_RECORD_ID
 * @property int $ISSUANCE_ID
 * @property string $CITIZENSHIP_ACQUISITION
 * @property \Carbon\Carbon $NATURALIZED_DATE
 * @property string $CERTIFICATE_NO
 * @property string $FATHER_LASTNAME
 * @property string $FATHER_FIRSTNAME
 * @property string $FATHER_MIDDLENAME
 * @property string $MOTHER_LASTNAME
 * @property string $MOTHER_FIRSTNAME
 * @property string $MOTHER_MIDDLENAME
 * @property string $PERIOD_OF_STAY
 * @property string $REASON_FOR_COMING
 * @property string $ID_TYPE
 * @property \Carbon\Carbon $ID_ISSUED_ON
 * @property \Carbon\Carbon $ID_UNTIL
 * @property int $BARANGAY_OFFICIAL_ID
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TIssuance $t_issuance
 *
 * @package App\Models
 */
class TBfTransientRecord extends Eloquent
{
	protected $table = 't_bf_transient_record';
	protected $primaryKey = 'TRANSIENT_RECORD_ID';
	public $timestamps = false;

	protected $casts = [
		'ISSUANCE_ID' => 'int',
		'BARANGAY_OFFICIAL_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'NATURALIZED_DATE',
		'ID_ISSUED_ON',
		'ID_UNTIL',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'ISSUANCE_ID',
		'CITIZENSHIP_ACQUISITION',
		'NATURALIZED_DATE',
		'CERTIFICATE_NO',
		'FATHER_LASTNAME',
		'FATHER_FIRSTNAME',
		'FATHER_MIDDLENAME',
		'MOTHER_LASTNAME',
		'MOTHER_FIRSTNAME',
		'MOTHER_MIDDLENAME',
		'PERIOD_OF_STAY',
		'REASON_FOR_COMING',
		'ID_TYPE',
		'ID_ISSUED_ON',
		'ID_UNTIL',
		'BARANGAY_OFFICIAL_ID',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_issuance()
	{
		return $this->belongsTo(\App\Models\TIssuance::class, 'ISSUANCE_ID');
	}
}
