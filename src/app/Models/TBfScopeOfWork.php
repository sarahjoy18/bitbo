<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfScopeOfWork
 * 
 * @property int $SCOPE_OF_WORK_ID
 * @property string $SCOPE_OF_WORK_NAME
 * @property string $SCOPE_OF_WORK_SPECIFY
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_barangay_clearances
 *
 * @package App\Models
 */
class TBfScopeOfWork extends Eloquent
{
	protected $table = 't_bf_scope_of_work';
	protected $primaryKey = 'SCOPE_OF_WORK_ID';
	public $timestamps = false;

	protected $fillable = [
		'SCOPE_OF_WORK_NAME',
		'SCOPE_OF_WORK_SPECIFY'
	];

	public function t_bf_barangay_clearances()
	{
		return $this->hasMany(\App\Models\TBfBarangayClearance::class, 'SCOPE_OF_WORK_ID');
	}
}
